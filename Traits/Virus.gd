extends Trait


func on_added(entity:Entity, params:Dictionary={}):
	entity.mind.crack = 'infect'
	entity.robustness = 2
