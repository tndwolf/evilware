extends Skill


func on_purchased(entity:Entity):
	entity.integrity += 8
