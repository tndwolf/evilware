extends Skill


func is_available(entity:Entity) -> bool:
	var res = entity.meta.get('bits', 0) >= cost
	if res and entity.security < 2:
		return true
	else:
		return false


func on_purchased(entity:Entity):
	entity.security += 1
