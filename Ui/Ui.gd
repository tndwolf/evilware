extends Node


var _canvas
var compiler_ui
var crack_button
var death_ui
var hack_button
var integrity_bar


func _toggle_play_ui(visible:bool):
	crack_button.visible = visible
	hack_button.visible = visible
	integrity_bar.visible = visible


func initialize(ui_canvas:Node):
	_canvas = ui_canvas
	compiler_ui = ui_canvas.find_node('CompilerUi')
	death_ui = ui_canvas.find_node('DeathUi')
	hack_button = ui_canvas.find_node('HackSkill')
	crack_button = ui_canvas.find_node('CrackSkill')
	integrity_bar = ui_canvas.find_node('Integrity')


func switch_to_compiler():
	GM.stop(GM.State.UI_PAUSE)
	GM.player.integrity += 10000
	update_integrity()
	compiler_ui.open()
	_toggle_play_ui(false)


func switch_to_play():
	compiler_ui.visible = false
	_toggle_play_ui(true)
	GM.resume_play()


func update_integrity():
	integrity_bar.maximum = GM.player._max_integrity
	integrity_bar.value = GM.player.integrity
