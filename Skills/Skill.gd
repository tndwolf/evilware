extends Node
class_name Skill


export(String, 'Cracking', 'Hacking', 'Refactoring') var category = 'Refactoring'
export(int, 16, 256, 16) var cost = 16
export(String, MULTILINE) var description = 'Description'
export(String) var overrides = ''


func get_aoe(actor:Entity, coords:Vector2) -> MapQuery:
	return Map.query().add(coords)


func get_damage(actor:Entity) -> Dictionary:
	return {
		'max': 1,
		'min': 0,
		'description': '0-1'
	}


func on_damage(actor:Entity, target:Entity, params:Dictionary) -> Dictionary:
	return params


func on_purchased(entity:Entity):
	pass


func on_used(actor:Entity, area:MapQuery):
	pass
