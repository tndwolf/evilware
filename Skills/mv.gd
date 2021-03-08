extends Skill


func on_purchased(entity:Entity):
	entity.hacking += 1


func on_used(actor:Entity, area:MapQuery):
	var target = area.first()
	GM.teleport(actor, target.grid_position)
