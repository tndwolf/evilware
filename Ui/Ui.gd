extends Node


var _canvas
var crack_button
var hack_button


func initialize(ui_canvas:Node):
	_canvas = ui_canvas
	hack_button = ui_canvas.find_node('HackSkill')
	crack_button = ui_canvas.find_node('CrackSkill')
