extends Node


const ATTACK_DURATION = 0.2
const CELL_SIZE = Vector2(20, 20)
const HIGH_DAMAGE = 16
const LOW_DAMAGE = 4
const MODERATE_DAMAGE = 8
const MOVE_DURATION = 0.4


const COLOR_FRIENDLY = Color('5eb7ff')
const COLOR_HIGH_CORRUPTION = Color('ff5b5b')
const COLOR_LOW_CORRUPTION = Color('5aff92')
const COLOR_MED_CORRUPTION = Color('ffd959')
const COLOR_NO_CORRUPTION = Color('5eb7ff')
const COLOR_OBJECT = Color('FFFFFF')
#const COLOR_HIGH_CORRUPTION = Color('FA8072')
#const COLOR_LOW_CORRUPTION = Color('98FB98')
#const COLOR_MED_CORRUPTION = Color('FFEE66')
#const COLOR_NO_CORRUPTION = Color('87CEFA')
const COLOR_THREATS = Color('ff5b5b')


var levels = {
	'/home': {
		'default_cell_type': Cell.Type.WALL,
		'description': "This is the the HOME of the Administrator. Perhaps surprisingly, eveything is tidy and orderly",
		'dig': 128,
		'next': '/home/develop',
		'programs': ['file'],
		'size': Vector2(64, 64),
		'threats': ['corrupted_file']
	},
	'/home/develop': {
		'default_cell_type': Cell.Type.WALL,
		'description': "Where new Programs are born. Hiding here, there may be Bugs that need to be squashed.",
		'dig': 128,
		'islands': 4,
		'next': '/tmp',
		'programs': ['file', 'program'],
		'size': Vector2(64, 64),
		'threats': ['corrupted_file', 'bug']
	},
	'/bin': {
		'default_cell_type': Cell.Type.WALL,
		'description': "The binary folder. You feel a shock of electricity as you enter, something dangerous approaches.",
		'dig': 256,
		'islands': 4,
		'next': '/sbin',
		'programs': ['program'],
		'size': Vector2(64, 64),
		'threats': ['trojan', 'virus', 'infected_program']
	},
	'/boot': {
		'default_cell_type': Cell.Type.WALL,
		'description': "The deepest part of the System, and possibly the most important: the Boot Sector.",
		'dig': 64,
		'is_last': true,
		'size': Vector2(64, 64),
		'threats': ['rootkit']
	},
	'/dev': {
		'default_cell_type': Cell.Type.ABYSS,
		'description': "Programs and Files here are actually interfaces to the System devices.",
		'dig': 256,
		'islands': 2,
		'island_type': Cell.Type.WALL,
		'next': '/bin',
		'programs': ['file', 'program'],
		'size': Vector2(64, 64),
		'threats': ['trojan', 'spyware', 'infected_program']
	},
	'/etc': {
		'default_cell_type': Cell.Type.WALL,
		'description': "The System configuration folder, where things start to get messy.",
		'dig': 256,
		'islands': 4,
		'next': '/dev',
		'programs': ['file'],
		'size': Vector2(64, 64),
		'threats': ['trojan', 'spyware', 'worm']
	},
	'/lib': {
		'default_cell_type': Cell.Type.WALL,
		'description': "All Pograms use the resources contained in the Libraries Folder. You hope to find the root of the problems in here...",
		'dig': 256,
		'next': '/boot',
		'programs': ['file', 'program'],
		'size': Vector2(64, 64),
		'threats': ['virus', 'rootkit']
	},
	'/sbin': {
		'default_cell_type': Cell.Type.WALL,
		'description': "The infection has spread to the System Binaries that inhabit this digital space.",
		'dig': 256,
		'islands': 4,
		'next': '/lib',
		'programs': ['program'],
		'size': Vector2(64, 64),
		'threats': ['trojan', 'virus', 'infected_program']
	},
	'/tmp': {
		'default_cell_type': Cell.Type.ABYSS,
		'description': "Temporary Files loiter around this sector. Threats from the Network can also be found.",
		'dig': 256,
		'next': '/var',
		'programs': ['file'],
		'size': Vector2(64, 64),
		'threats': ['corrupted_file', 'bug', 'adware']
	},
	'/var': {
		'default_cell_type': Cell.Type.ABYSS,
		'description': "Random files, logs and miscellanea. This sector is a breeding ground for Threats to the System",
		'dig': 256,
		'islands': 3,
		'island_type': Cell.Type.WALL,
		'next': '/etc',
		'programs': ['file', 'program'],
		'size': Vector2(64, 64),
		'threats': ['corrupted_file', 'spyware', 'adware']
	},
	'unit_test': {
		'default_cell_type': Cell.Type.WALL,
		'description': "The testing area for in development software",
		'next': '/home',
		'size': Vector2(128, 128)
	}
}


var templates = {
	'adware': {
		'integrity': 1,
		'meta': {'bits': 4, 'description': 'Very annoying, with a tendency to slip away'},
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Adware.tscn"),
		'traits': ['Annoy', 'Teleport']
	},
	'bug': {
		'meta': {'bits': 2, 'description': 'A software bug, ready to be squashed'},
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Bug.tscn"),
		'traits': ['Bug', 'Corruption1', 'Mob']
	},
	'compiler': {
		'faction': Entity.Faction.PLAYER,
		'meta': {'use_type': 'compiler', 'description': 'An upgrade Terminal left for you by the User'},
		'res': preload("res://Entitites/Objects/Compiler.tscn"),
		'traits': []
	},
	'corrupted_file': {
		'integrity': 1,
		'meta': {'bits': 1, 'description': '?|>@[}%]'},
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/CorruptedFile.tscn"),
		'traits': ['Corrupted', 'Mob']
	},
	'data': {
		'meta': {'use_type': 'data', 'value': 8},
		'res': preload("res://Entitites/Objects/Data.tscn"),
		'traits': []
	},
	'directory_pointer': {
		'meta': {'use_type': 'cd', 'value': '/home', 'description': 'Changes (exit) to another Directory'},
		'res': preload("res://Entitites/Objects/DirPointer.tscn"),
		'traits': []
	},
	'evilware': {
		'integrity': 20,
		'meta': {'bits': 32, 'description': 'The Source of all Evil ^(;,;)^'},
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Evilware.tscn"),
		'traits': ['Corruption3', 'Evilware']
	},
	'file': {
		'faction': Entity.Faction.PLAYER,
		'meta': {'file': true, 'description': 'Lorem ipsum dolor sit amet...'},
		'mind': preload("res://Entitites/Minds/NeutralMind.gd"),
		'res': preload("res://Entitites/Objects/File.tscn"),
		'traits': []
	},
	'fork': {
		'integrity': 4,
		'faction': Entity.Faction.PLAYER,
		'mind': preload("res://Entitites/Minds/Mind.gd"),
		'res': preload("res://Entitites/Player/Fork.tscn"),
		'traits': ['Fork']
	},
	'infected_program': {
		'integrity': 4,
		'meta': {'bits': 4, 'description': 'This program has been corrupted by a Virus'},
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/InfectedProgram.tscn"),
		'traits': ['Infected']
	},
	'player': {
		'faction': Entity.Faction.PLAYER,
		'mind': preload("res://Entitites/Minds/PlayerMind.gd"),
		'res': preload("res://Entitites/Player/Player.tscn"),
		'traits': ['Player']
	},
	'pointer': {
		'meta': {'use_type': 'pointer', 'value': null},
		'res': preload("res://Entitites/Objects/Pointer.tscn")
	},
	'program': {
		'faction': Entity.Faction.PLAYER,
		'meta': {'program': true, 'description': 'One of the many programs living in the System'},
		'mind': preload("res://Entitites/Minds/NeutralMind.gd"),
		'res': preload("res://Entitites/Objects/Program.tscn"),
		'traits': []
	},
	'rootkit': {
		'integrity': 12,
		'meta': {'bits': 12, 'description': 'The toughest malware, its damage is almost irreversible'},
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Rootkit.tscn"),
		'traits': ['Corruption3']
	},
	'spyware': {
		'integrity': 2,
		'meta': {'bits': 4, 'description': "Ready to steal the User's data, they live in hiding"},
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Spyware.tscn"),
		'traits': ['Spy']
	},
	'trojan': {
		'integrity': 4,
		'meta': {'bits': 8, 'description': 'The frontline of a remote attack'},
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Trojan.tscn"),
		'traits': ['Corruption2']
	},
	'virus': {
		'integrity': 6,
		'meta': {'bits': 8, 'description': 'Remove them before they infect other programs or files'},
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Virus.tscn"),
		'traits': ['Virus', 'Corruption2']
	},
	'worm': {
		'meta': {'bits': 2, 'description': 'They have a nasty habit to reproduce esponentially'},
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Worm.tscn"),
		'traits': ['Worm', 'Mob']
	}
}
