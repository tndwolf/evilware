extends Trait


func on_added(entity:Entity, params:Dictionary={}):
	if randi() % 2 == 0:
		entity.frame += 1


func on_death(entity:Entity, params:Dictionary={}) -> Dictionary:
	GM.spawn_at('program', entity.grid_position)
	return params
