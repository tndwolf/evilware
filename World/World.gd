extends Node2D


onready var credits = $TitleLayer/CreditsLabel
onready var logo = $TitleLayer/LogoPanel
onready var help_box = $TitleLayer/MainPanel/HelpBox
onready var main_panel = $TitleLayer/MainPanel
onready var opt_box = $TitleLayer/MainPanel/OptBox
onready var title_box = $TitleLayer/MainPanel/TitleBox
onready var start_box = $TitleLayer/MainPanel/StartBox


func _ready():
	randomize()
	UI.initialize(get_node("UiLayer"))
	GM.world = $World
#	GM.goto_level('/home')
#	UI.update_integrity()


func _on_RespawnButton_pressed():
	GM.kill(GM.player, true)
	UI.death_ui.visible = false
	GM.goto_level('/home')


func _on_CloseMsgButton_pressed():
	UI.switch_to_play()


func _on_StartBtn_pressed():
	credits.visible = false
	title_box.visible = false
#	start_box.visible = true
	logo.visible = false
	main_panel.visible = false
	GM.goto_level('/home')


func _on_StartWarrior_pressed():
	logo.visible = false
	main_panel.visible = false
	GM.goto_level('/home')
	GM.player.mind.add_skill(GM.get_skill('delete'), true)


func _on_StartWizard_pressed():
	logo.visible = false
	main_panel.visible = false
	GM.goto_level('/lib')
	GM.player.mind.add_skill(GM.get_skill('mv'), true)


func _on_HelpBtn_pressed():
	title_box.visible = false
	help_box.visible = true


func _on_CloseHelpButton_pressed():
	help_box.visible = false
	title_box.visible = true


func _on_HackSkill_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			GM.player.mind.next_hack()
		elif event.button_index == BUTTON_RIGHT:
			var sk = GM.get_skill(GM.player.mind.hack)
			UI.show_message('> %s\n> %s' % [sk.name, sk.description])


func _on_MusSlider_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)


func _on_SfxSlider_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)


func _on_OptBackButton_pressed():
	opt_box.visible = false
	title_box.visible = true


func _on_OptBtn_pressed():
	title_box.visible = false
	opt_box.visible = true


func _on_CrackSkill_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			GM.player.mind.next_crack()
		elif event.button_index == BUTTON_RIGHT:
			var sk = GM.get_skill(GM.player.mind.crack)
			UI.show_message('> %s\n> %s' % [sk.name, sk.description])
