extends Skill


func on_purchased(entity:Entity):
	entity.hacking += 1


func on_used(actor:Entity, area:MapQuery) -> bool:
	var target = area.first(true)
	if target.is_empty():
		GM.teleport(actor, target.grid_position, true)
		return true
	else:
		return false
