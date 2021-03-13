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
	var crack = GM.get_action('Crack')
	for cell in Map.query().burst(actor.grid_position, 1).collect():
		for e in cell.entities():
			if e != actor and e != target and e.is_character() and e.faction == Entity.Faction.ENEMY:
				var dam = get_damage(actor)
				var atk = crack.calc_damage(actor, e, dam)
				print('kill attacks %s: %d' % [e, atk])
				if atk > 0:
					target.add_child(crack.Fx.instance())
				GM.damage(actor, e, atk)
	return params
