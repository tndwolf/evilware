extends Trait


func on_added(entity:Entity, params:Dictionary={}):
	entity._max_integrity = 16
	entity.integrity = 16
	entity.meta['bits'] = 0
#	entity.mind.next_hack(GM.world.get_parent().find_node('HackSkill'))
	entity.mind.next_hack()
	entity.mind.next_crack()


func on_round(entity:Entity):
	Map.update_fov(entity.grid_position)
