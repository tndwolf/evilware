extends Skill


func get_aoe(actor:Entity, coords:Vector2) -> MapQuery:
	return Map.query().burst(coords, 2)


func on_purchased(entity:Entity):
	entity.hacking += 1


func on_used(actor:Entity, area:MapQuery):
	for cell in area.collect():
		cell.corruption_resist = 3
		match cell.corruption:
			Cell.Corruption.LOW:
				cell.corruption = Cell.Corruption.NONE
			Cell.Corruption.MEDIUM:
				cell.corruption = Cell.Corruption.NONE
			Cell.Corruption.HIGH:
				cell.corruption = Cell.Corruption.LOW
#		if cell.corruption > 0:
#			cell.corruption -= 2 
