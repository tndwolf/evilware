extends Trait


#func on_added(entity:Entity, params:Dictionary={}):
#	entity.mind.crack = 'delete'


func on_round(entity:Entity):
	var cells = Map.query().burst(entity.grid_position, 1).collect()
	for cell in cells:
		if cell.corruption < Cell.Corruption.HIGH:
			cell.corruption += 1
#		if cell.corruption < Cell.Corruption.HIGH:
#			cell.corruption = Cell.Corruption.MEDIUM
