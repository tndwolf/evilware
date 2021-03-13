extends Node


var bits_icon
var bits_label
var _canvas
var compiler_ui
var crack_button
var death_ui
var flash
var hack_button
var logo
var message_ui
var integrity_bar


func _toggle_play_ui(visible:bool):
	bits_icon.visible = visible
	crack_button.visible = visible
	hack_button.visible = visible
	integrity_bar.visible = visible


func death():
	GM.stop(GM.State.UI_PAUSE)
	death_ui.visible = true
	_toggle_play_ui(false)


func fade(direction:int):
	var fade_anim = flash.get_node('FadeAnimation')
	if direction == 1:
		fade_anim.play('fade_to_screen')
	else:
		fade_anim.play('fade_to_black')

func initialize(ui_canvas:Node):
	_canvas = ui_canvas
	bits_icon = ui_canvas.find_node('BitsIcon')
	bits_label = ui_canvas.find_node('BitsLabel')
	compiler_ui = ui_canvas.find_node('CompilerUi')
	death_ui = ui_canvas.find_node('DeathUi')
	flash = ui_canvas.find_node('Flash')
	hack_button = ui_canvas.find_node('HackSkill')
	message_ui = ui_canvas.find_node('MessageUi')
	crack_button = ui_canvas.find_node('CrackSkill')
	integrity_bar = ui_canvas.find_node('Integrity')


func show_message(msg:String):
	GM.stop(GM.State.UI_PAUSE)
	var label:Label = message_ui.get_node('MessageLabel')
	label.text = msg
	message_ui.visible = true
	_toggle_play_ui(false)


func show_win(msg:String):
	GM.stop(GM.State.UI_PAUSE)
	var label:Label = message_ui.get_node('MessageLabel')
	label.text = msg
	message_ui.visible = true
	var btn = message_ui.get_node('CloseMsgButton')
	btn.visible = false
	_toggle_play_ui(false)


func switch_to_compiler():
	GM.stop(GM.State.UI_PAUSE)
	GM.player.integrity += 10000
	update_integrity()
	compiler_ui.open()
	_toggle_play_ui(false)


func switch_to_play():
	if flash.color == Color.black:
		fade(1)
	compiler_ui.visible = false
	message_ui.visible = false
	update_bits()
	_toggle_play_ui(true)
	GM.resume_play()


func update_bits():
	bits_label.text = str(GM.player.meta.get('bits', 0))
	bits_label.get_node('BitsFx').emitting = true


func update_integrity():
	integrity_bar.maximum = GM.player._max_integrity
	integrity_bar.value = GM.player.integrity
