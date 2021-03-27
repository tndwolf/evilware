extends Panel


var _bits = 0
onready var _bits_label = $VBoxContainer/HBoxContainer2/BitsLabel
onready var _buy_btn = $VBoxContainer/HBoxContainer2/BuyButton
var crack_list
var _default_text = "> Pick a Skill to show its description"
onready var _description = $VBoxContainer/DescriptionLabel
var hack_list
var _last_selected = null
var ref_list
var _selected_skill = null


# Called when the node enters the scene tree for the first time.
func _ready():
	crack_list = find_node('CrackList').set_title('Cracking')
	crack_list.set_list(_list_skills('Cracking'))
	hack_list = find_node('HackList').set_title('Hacking')
	hack_list.set_list(_list_skills('Hacking'))
	ref_list = find_node('RefList').set_title('Refactoring')
	ref_list.set_list(_list_skills('Refactoring'))
	_default_text = _description.text#bbcode_text


func _list_skills(category:String) -> Array:
	var skills = GM.get_skills(category)
	var res = []
	for skill in skills:
		res.append(skill.name)
	return res


func _on_skill_inspected(pressed:bool, item:String, btn:Button):
	_buy_btn.disabled = true
	if pressed:
		if _last_selected:
			_last_selected.pressed = false
		_last_selected = btn
		var skill = GM.get_skill(item)
		var text = '> %s ()\n> %s\n> Cost: %d bits [TOO HIGH]' % [item, skill.description, skill.cost]
		_description.text = text
		_selected_skill = skill
	else:
		_last_selected = null
		_selected_skill = null
		_description.text = _default_text


func _on_skill_toggled(pressed:bool, item:String, btn:Button):
	_buy_btn.disabled = false
	if pressed:
		if _last_selected:
			_last_selected.pressed = false
		_last_selected = btn
		var skill = GM.get_skill(item)
		var text = '> %s ()\n> %s\n> Cost: %d bits' % [item, skill.description, skill.cost]
		_description.text = text
		_selected_skill = skill
	else:
		_last_selected = null
		_selected_skill = null
		_description.text = _default_text


func _on_CloseButton_pressed():
	UI.switch_to_play()


func _on_BuyButton_pressed():
	GM.player.mind.add_skill(_selected_skill)
	GM.player.mind.set_skill(_selected_skill)
	_selected_skill = null
	_last_selected = null
	_description.text = _default_text
	_update()
	print(GM.player.mind._available_cracks)
	print(GM.player.mind._available_hacks)


func open():
	visible = true
	_update()
	
func _update():
	_bits = int(GM.player.meta.get('bits', 0))
	_bits_label.text = '%s bits' % [_bits]
	crack_list.set_list(_list_skills('Cracking'))
	hack_list.set_list(_list_skills('Hacking'))
	ref_list.set_list(_list_skills('Refactoring'))
