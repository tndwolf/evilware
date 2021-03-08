extends Skill


func on_purchased(entity:Entity):
	entity.hacking += 1


func on_used(actor:Entity, area:MapQuery):
	GM.spawn_at('Fork', area.first().grid_position)
