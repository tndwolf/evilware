extends Trait


func on_added(entity:Entity, params:Dictionary={}):
	entity.meta['bits'] = 0


func on_round(entity:Entity):
	Map.update_fov(entity.grid_position)
