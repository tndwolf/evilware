extends Trait


func on_added(entity:Entity, params:Dictionary={}):
	entity.integrity = 1
	entity.robustness = 0
	entity.security = 0
