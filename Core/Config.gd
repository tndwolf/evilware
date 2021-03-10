extends Node


const ATTACK_DURATION = 0.2
const CELL_SIZE = Vector2(36, 36)
const HIGH_DAMAGE = 16
const LOW_DAMAGE = 4
const MODERATE_DAMAGE = 8
const MOVE_DURATION = 0.4


const COLOR_FRIENDLY = Color('CFECFF')
const COLOR_HIGH_CORRUPTION = Color('FA8072')
const COLOR_LOW_CORRUPTION = Color('98FB98')
const COLOR_MED_CORRUPTION = Color('FFEE66')
const COLOR_NO_CORRUPTION = Color('87CEFA')
const COLOR_THREATS = Color('FFA07A')


var levels = {
	'/home': {
		'default_cell_type': Cell.Type.WALL,
		'description': "This is the the HOME of the Administrator. Perhaps surprisingly, eveything is tidy and orderly",
		'dig': 32,
		'next': '/home/develop',
		'size': Vector2(64, 64)
	},
	'/home/develop': {
		'default_cell_type': Cell.Type.WALL,
		'description': "Where new Programs are born. Hiding here, there may be Bugs that need to be squashed.",
		'next': '/boot',
		'size': Vector2(128, 128)
	},
	'/boot': {
		'default_cell_type': Cell.Type.WALL,
		'description': "The deepest part of the System, and possibly the most important: the Boot Sector.",
		'size': Vector2(128, 128)
	},
	'/test': {
		'default_cell_type': Cell.Type.WALL,
		'description': "The testing area for in development software",
		'dig': 32,
		'size': Vector2(32, 32)
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
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Adware.tscn"),
		'traits': ['Annoy', 'Teleport']
	},
	'bug': {
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Bug.tscn"),
		'traits': ['Bug', 'Corruption1']
	},
	'corrupted_file': {
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/CorruptedFile.tscn"),
		'traits': ['Corrupted']
	},
	'data': {
		'meta': {'use_type': 'data', 'value': 8},
		'res': preload("res://Entitites/Objects/Data.tscn"),
		'traits': []
	},
	'directory_pointer': {
		'meta': {'use_type': 'cd', 'value': '/home'},
		'res': preload("res://Entitites/Objects/DirPointer.tscn"),
		'traits': []
	},
	'file': {
		'faction': Entity.Faction.PLAYER,
		'mind': preload("res://Entitites/Minds/NeutralMind.gd"),
		'res': preload("res://Entitites/Objects/File.tscn"),
		'traits': []
	},
	'fork': {
		'faction': Entity.Faction.PLAYER,
		'mind': preload("res://Entitites/Minds/Mind.gd"),
		'res': preload("res://Entitites/Player/Player.tscn"),
		'traits': ['Fork']
	},
	'infected_program': {
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
		'mind': preload("res://Entitites/Minds/NeutralMind.gd"),
		'res': preload("res://Entitites/Objects/Program.tscn"),
		'traits': []
	},
	'rootkit': {
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Rootkit.tscn"),
		'traits': ['Corruption3']
	},
	'spyware': {
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Spyware.tscn"),
		'traits': []
	},
	'trojan': {
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Trojan.tscn"),
		'traits': []
	},
	'virus': {
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Virus.tscn"),
		'traits': []
	},
	'worm': {
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Worm.tscn"),
		'traits': ['Worm']
	}
}
