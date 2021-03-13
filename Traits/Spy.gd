extends Trait


func on_added(entity:Entity, params:Dictionary={}):
	entity.mind.crack = 'sneak'
	entity.self_modulate = Color.transparent
