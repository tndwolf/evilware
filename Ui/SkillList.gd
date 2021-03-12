extends Control


onready var SkillBtn = preload("res://Ui/SkillSelectButton.tscn")


func clear():
	var sc = find_node('SkillContainer')
	while sc.get_child_count() != 0:
		sc.remove_child(sc.get_child(0))
	return self


func is_possessed(skill_name)->bool:
	return GM.player.mind.has_skill(skill_name)


func is_purchasable(skill_name)->bool:
	if is_possessed(skill_name):
		return false
	var skill = GM.get_skill(skill_name)
	if skill.cost <= GM.player.meta.get('bits', 0):
		return true
	else:
		return false


func set_list(list:Array) -> Control:
	if !GM.player:
		return self
	clear()
	var sc = find_node('SkillContainer')
	for item in list:
		var btn = SkillBtn.instance()
		btn.text = item
		if is_purchasable(item):
			btn.disabled = false
			btn.connect("toggled", find_parent('CompilerUi'), '_on_skill_toggled', [item, btn])
		elif is_possessed(item):
			btn.disabled = true
			btn.modulate = Color('#dfdfdf')
			btn.text += ' (ready)'
		else:
			btn.disabled = true
			btn.modulate = Color('#dfdfdf')
			btn.text += ' (unavailable)'
		sc.add_child(btn)
	return self


func set_title(title:String) -> Control:
	$TitleLabel.text = title
	return self
