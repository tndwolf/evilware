extends Skill


func get_damage(actor:Entity) -> Dictionary:
	var minimum = 0
	var maximum = Config.MODERATE_DAMAGE
	return {
		'max': maximum,
		'min': minimum,
		'description': '%d-%d' % [minimum, maximum]
	}


func on_damage(actor:Entity, target:Entity, params:Dictionary) -> Dictionary:
	GM.add_trait(target, 'Weakened')
	return params
