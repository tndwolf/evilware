extends Trait


func on_death(entity:Entity, params:Dictionary={}) -> Dictionary:
	GM.spawn_at('file', entity.grid_position)
	return params
