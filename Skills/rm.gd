extends Skill


func get_damage(actor:Entity) -> Dictionary:
	var minimum = 0
	var maximum = Config.LOW_DAMAGE
	return {
		'max': maximum,
		'min': minimum,
		'description': '%d-%d' % [minimum, maximum]
	}
