extends Node
class_name Trait


func on_added(entity:Entity, params:Dictionary={}):
	print('adding %s to %s' % [name, entity])


func on_damage(entity:Entity, params:Dictionary={}) -> Dictionary:
	return params


func on_death(entity:Entity, params:Dictionary={}) -> Dictionary:
	return params


func on_round(entity:Entity):
	pass
