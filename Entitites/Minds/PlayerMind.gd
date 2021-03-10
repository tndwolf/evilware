extends Mind
class_name PlayerMind


var _available_cracks = ['rm', 'delete', 'kill', 'killall', 'term', 'stop']
var _available_hacks = ['ps', 'fork', 'sleep', 'mv', 'chmod', 'defrag']
var _hack_cooldown = 0
var _pre_target = null
var _target = null


func hack(coords:Vector2) -> bool:
	var res = false
	if _hack_cooldown == 0:
		res = GM.try_action('Hack', _entity, {'coords': coords, 'skill': hack})
	if res:
		_hack_cooldown = 3
	return res


func next_crack(btn:Control=null):
	btn = UI.crack_button
	if crack == null:
		crack = 'ps'
	for i in len(_available_cracks):
		if _available_cracks[i] == crack:
			crack = _available_cracks[(i+1) % len(_available_cracks)]
			btn.set_icon(GM.get_skill(crack).icon_frame)
			btn.hint_tooltip = crack
			print('selected crack %s' % crack)
			break


func next_hack(btn:Control=null):
	btn = UI.hack_button
	if hack == null:
		hack = 'ps'
	for i in len(_available_hacks):
		if _available_hacks[i] == hack:
			hack = _available_hacks[(i+1) % len(_available_hacks)]
			btn.set_icon(GM.get_skill(hack).icon_frame)
			btn.hint_tooltip = hack
			print('selected hack %s' % hack)
			break


func on_click(event:InputEventMouseButton, grid_position:Vector2):
	if event.pressed and event.button_index == BUTTON_LEFT:
		_pre_target = grid_position
	elif grid_position == _pre_target:
		_pre_target = null
		_target = grid_position
#	print('%s %s' % [event, grid_position])


func run() -> bool:
	if !_started:
		on_round()
		_hack_cooldown = clamp(_hack_cooldown - 1, 0, 3)
		UI.hack_button.set_progress(_hack_cooldown, 3)
		_started = true
	var res = false
	if _target:
		res = hack(_target)
		_target = null
	else:
		var dx = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
		var dy = Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
		var direction = Vector2(dx, dy)
		if dx != 0 or dy != 0:
			res = GM.try_action('Move', _entity, {'direction': direction})
	_started = !res
	return res
