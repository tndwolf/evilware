extends Trait


func on_death(entity:Entity, params:Dictionary={}) -> Dictionary:
	GM.spawn_at('program', entity.grid_position)
	return params
