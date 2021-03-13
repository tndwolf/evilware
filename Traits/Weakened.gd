extends Trait


var Fx = preload("res://Traits/WeakenedFX.tscn")
export var ttl = 3


func on_added(entity:Entity, params:Dictionary={}):
	entity.meta['weakened'] = ttl
	entity.add_child(Fx.instance())
	weaken(entity, 4)


func on_round(entity:Entity):
	var to_go = entity.meta.get('weakened', 1) - 1
	entity.meta['weakened'] = to_go
	if to_go == 0:
		entity.meta.erase('weakened')
		entity.meta.erase('weakened:amount')
		entity.remove_child(entity.get_node("WeakenedFX"))
		GM.remove_trait(entity, 'Weakened')


func weaken(target:Entity, amount:int):
	target.meta['weakened:amount'] = amount
