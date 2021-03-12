extends Node
class_name Trait


func on_added(entity:Entity, params:Dictionary={}):
#	print('adding %s to %s' % [name, entity])
	pass


func on_damage(actor:Entity, target:Entity, value:int, skill:Skill, params:Dictionary={}) -> int:
	return value


func on_death(entity:Entity, params:Dictionary={}) -> Dictionary:
	return params


func on_round(entity:Entity):
	pass
