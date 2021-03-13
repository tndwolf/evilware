extends Skill


func get_damage(actor:Entity) -> Dictionary:
	var minimum = 0
	var maximum = Config.MODERATE_DAMAGE
	return {
		'max': maximum,
		'min': minimum,
		'description': '%d-%d' % [minimum, maximum]
	}


func infect_file(target:Entity):
	GM.spawn_at('corrupted_file', target.grid_position)
	GM.kill(target)


func infect_program(actor:Entity, target:Entity):
	GM.spawn_at('infected_program', target.grid_position)
	GM.kill(target)


func on_damage(actor:Entity, target:Entity, params:Dictionary) -> Dictionary:
	if 'file' in target.meta:
		infect_file(target)
		actor.mind.target = null
	elif 'program' in target.meta:
		infect_program(actor, target)
		actor.mind.target = null
	return params
