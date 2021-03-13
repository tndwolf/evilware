extends Trait


func on_added(entity:Entity, params:Dictionary={}):
	entity._max_integrity = 16
	entity.integrity = 16
	entity.meta['bits'] = 0
	entity.meta['description'] = 'A custom made anti-malware from the User, ready for testing' 
	entity.mind.set_skill(GM.get_skill('ps'))
	entity.mind.set_skill(GM.get_skill('rm'))
#	entity.mind.set_skill(GM.get_skill(entity.mind._available_cracks[0]))


func on_round(entity:Entity):
	Map.update_fov(entity.grid_position)
