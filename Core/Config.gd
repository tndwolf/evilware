extends Node


const ATTACK_DURATION = 0.2
const CELL_SIZE = Vector2(36, 36)
const HIGH_DAMAGE = 16
const LOW_DAMAGE = 4
const MODERATE_DAMAGE = 8
const MOVE_DURATION = 0.4


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
	'bug': {
		'mind': preload("res://Entitites/Minds/ThreatMind.gd"),
		'res': preload("res://Entitites/Threats/Bug.tscn"),
		'traits': ['Bug', 'Corruption1']
	},
	'data': {
		'meta': {'use_type': 'data', 'value': 8},
		'res': preload("res://Entitites/Objects/Data.tscn")
	},
	'directory_pointer': {
		'meta': {'use_type': 'cd', 'value': '/home'},
		'res': preload("res://Entitites/Objects/DirPointer.tscn")
	},
	'fork': {
		'faction': Entity.Faction.PLAYER,
		'mind': preload("res://Entitites/Minds/Mind.gd"),
		'res': preload("res://Entitites/Player/Player.tscn"),
		'traits': ['Fork']
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
	}
}
