extends Action


func attempt(actor:Entity, params:Dictionary) -> bool:
	var skill_id = params.get('skill', '')
	if skill_id:
		var coords = params.get('coords', -Vector2.ONE)
		var skill = GM.get_skill(skill_id)
		if coords != -Vector2.ONE and skill:
			return skill.on_used(actor, skill.get_aoe(actor, coords))
	return false
