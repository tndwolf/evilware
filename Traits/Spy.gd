extends Trait


func on_added(entity:Entity, params:Dictionary={}):
	entity.mind.crack = 'sneak'
	entity.self_modulate = Color.transparent


func on_damage(actor:Entity, target:Entity, value:int, skill:Skill, params:Dictionary={}) -> int:
	target.self_modulate = Config.COLOR_THREATS
	return value
