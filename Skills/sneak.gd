extends Skill


func get_damage(actor:Entity) -> Dictionary:
	var minimum = 0
	var maximum = Config.LOW_DAMAGE
	return {
		'max': maximum,
		'min': minimum,
		'description': '%d-%d' % [minimum, maximum]
	}


func on_damage(actor:Entity, target:Entity, params:Dictionary) -> Dictionary:
	actor.self_modulate = Config.COLOR_THREATS
	return params
