extends Skill


func get_aoe(actor:Entity, coords:Vector2) -> MapQuery:
	return Map.query().burst(coords, 2)


func on_purchased(entity:Entity):
	entity.hacking += 1


func on_used(actor:Entity, area:MapQuery):
	for cell in area.collect():
		if cell.corruption > 0:
			cell.corruption -= 2 
