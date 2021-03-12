extends Action


func attempt(actor:Entity, params:Dictionary) -> bool:
	var res = false
	var target = params.get('target', null)
	if actor == GM.player and target:
		var use_type = target.meta.get('use_type', '')
		match use_type:
			'cd':
				GM.goto_level(target.meta.get('value', '/home'))
			
			'compiler':
				UI.switch_to_compiler()
				
			'data':
				actor.meta['bits'] += target.meta.get('value', 1)
				print('total bits %d' % actor.meta['bits'])
				GM.kill(target)
			
#			'cd':
#				GM.teleport(actor, target.meta.get('pointer', actor.grid_position))
		res = true
	return res
