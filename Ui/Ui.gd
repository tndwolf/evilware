extends Node


var _canvas
var crack_button
var hack_button
var integrity_bar


func initialize(ui_canvas:Node):
	_canvas = ui_canvas
	hack_button = ui_canvas.find_node('HackSkill')
	crack_button = ui_canvas.find_node('CrackSkill')
	integrity_bar = ui_canvas.find_node('Integrity')
