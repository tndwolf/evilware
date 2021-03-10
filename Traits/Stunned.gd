extends Trait


var Fx = preload("res://Traits/StunnedFX.tscn")
export var ttl = 3


func on_added(entity:Entity, params:Dictionary={}):
	entity.meta['stunned'] = ttl
	entity.add_child(Fx.instance())


func on_round(entity:Entity):
	var to_go = entity.meta.get('stunned', 1) - 1
	entity.meta['stunned'] = to_go
	print ('%d vs %s' % [to_go, entity.meta])
	if to_go == 0:
		entity.meta.erase('stunned')
		entity.remove_child(entity.get_node("StunnedFX"))
		GM.remove_trait(entity, 'Stunned')
