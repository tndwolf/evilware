extends Node
class_name Mind


var crack = 'rm'
var _entity = null
var hack = null
var _started = false


func on_round():
	for trait_id in _entity._traits:
		GM.get_trait(trait_id).on_round(_entity)


func run() -> bool:
	return true
