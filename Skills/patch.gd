extends Skill


func is_available(entity:Entity) -> bool:
	var res = entity.meta.get('bits', 0) >= cost
	if res and entity._max_integrity < 32:
		return true
	else:
		return false


func on_purchased(entity:Entity):
	entity._max_integrity += 8
	entity.integrity = entity._max_integrity
	UI.update_integrity()
