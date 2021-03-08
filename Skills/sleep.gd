extends Skill


func on_purchased(entity:Entity):
	entity.hacking += 1


func on_used(actor:Entity, area:MapQuery):
	for cell in area.collect():
		for entity in cell.entities():
			if entity.faction != actor.faction:
				GM.add_trait(entity, 'Stunned')
