extends Control


func _ready():
	pass # Replace with function body.


func set_list(list:Array):
	var sc = $VBoxContainer/TitleLabel/SkillContainer
	for item in list:
		var btn = Button.new()
		btn.align = Button.ALIGN_LEFT
		btn.text = item
		sc.add_child(btn)
