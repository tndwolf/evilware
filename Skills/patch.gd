extends Skill


func on_purchased(entity:Entity):
	entity.security += 1
