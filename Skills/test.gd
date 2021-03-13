extends Skill


func is_available(entity:Entity) -> bool:
	var res = entity.meta.get('bits', 0) >= cost
	if res and entity.robustness < 3:
		return true
	else:
		return false


func on_purchased(entity:Entity):
	entity.robustness += 1
