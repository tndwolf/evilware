extends Node


enum State {
	PLAY,
	PAUSE,
	UI_PAUSE
}


var _actions = preload("res://Actions/Actions.tscn").instance()
var _actors = []
var _actor_index = 0
var DamageLabel = preload("res://Ui/DamageLabel.tscn")
var _level = {}
var _mouse_move = false
var _objects = []
var player = null setget set_player, get_player
var _skills = preload("res://Skills/Skills.tscn").instance()
var state = State.UI_PAUSE
var TeleportFx = preload("res://Core/TeleportInFx.tscn")
var _traits = preload("res://Traits/Traits.tscn").instance()
var _threats_count = 0
var world = null setget set_world, get_world


func _process(delta):
	if state == State.PLAY:
		var done = false
		var actor = _actors[_actor_index]
		while !done:
			if actor.is_idle() and state == State.PLAY and actor.run():
				_actor_index = (_actor_index + 1) % len(_actors)
				actor = _actors[_actor_index]
			else:
				done = true


func _unhandled_input(event):
	if event.is_action_pressed("next_hack"):
		player.mind.next_hack(world.get_parent().find_node('HackSkill'))
	elif event.is_action_pressed("next_crack"):
		player.mind.next_crack(world.get_parent().find_node('CrackSkill'))
	if event.is_action_pressed('mouse_move'):
		var mouse_pos:Vector2 = world.get_local_mouse_position()
		var player_pos:Vector2 = player.position
		player.mind._mouse_direction = player_pos.direction_to(mouse_pos).round()
		_mouse_move = true
#		print('Move direction %s' % player.mind._mouse_direction)
	elif _mouse_move == true and event is InputEventMouseMotion:
		var mouse_pos:Vector2 = world.get_local_mouse_position()
		var player_pos:Vector2 = player.position
		player.mind._mouse_direction = player_pos.direction_to(mouse_pos).round()
	elif event.is_action_released("mouse_move"):
		player.mind._mouse_direction = null
		_mouse_move = false


func add_trait(entity:Entity, trait_id:String) -> Entity:
	if !trait_id in entity._traits:
		var trait = get_trait(trait_id)
		if trait:
			entity._traits.append(trait_id)
			trait.on_added(entity)
	return entity


func clear() -> Node:
	for entity in _objects:
		print('clearing %s' % entity.name)
		Map.at(entity.grid_position).move_out(entity)
		world.remove_child(entity)
#		entity.queue_free()
	_objects.clear()
	for entity in _actors:
		if entity != player:
			Map.at(entity.grid_position).move_out(entity)
			world.remove_child(entity)
#			entity.queue_free()
	_actors.clear()
	_actor_index = 0
	if player:
		_actors.append(player)
	_threats_count = 0
	return self


func damage(actor:Entity, target:Entity, value:int, skill:Skill=null, params:Dictionary={}) -> Dictionary:
#	print('dealing %d damage to %s' % [value, target])
	if value > 0:
		for t in target._traits:
			value = get_trait(t).on_damage(actor, target, value, skill, params)
		if value > 0:
			if actor == player or target == player:
				shake()
			var dam_label = DamageLabel.instance()
			dam_label.text = '-%d' % value
			target.add_child(dam_label)
			if target.integrity - value < 0:
				params['dead'] = true
			target.integrity -= value
			if skill != null:
				skill.on_damage(actor, target, params)
			if target == player:
				UI.integrity_bar.value = target.integrity
	return params


func fade(color:Color, duration:float) -> Node:
	var flash = world.get_parent().find_node('Flash')
	var tween = Tween.new()
	var from = flash.color
	tween.interpolate_property(flash, 'color', from, color, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	world.add_child(tween)
	tween.start()
	return self


func flash(color:Color=Color(1,1,1,0.25), duration:float=0.05) -> Node:
	var flash = world.get_parent().find_node('Flash')
	var tween = Tween.new()
	tween.interpolate_property(flash, 'color', Color.transparent, color, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(flash, 'color', color, Color.transparent, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration)
	world.add_child(tween)
	tween.start()
	return self


func get_action(action_id:String) -> Skill:
	var res = _actions.get_node(action_id)
	return res if res else null


func get_player() -> Node2D:
	return player


func get_skill(skill_id:String) -> Skill:
	var res = _skills.get_node(skill_id)
	return res if res else null


func get_skills(category:String='') -> Array:
	var res = []
	for skill in _skills.get_children():
		if category == '':
			res.append(skill)
		elif skill.category == category:
			res.append(skill)
	return res


func get_trait(trait_id:String) -> Trait:
	var res = _traits.get_node(trait_id)
	return res if res else null


func get_world() -> Node:
	return world


func goto_level(level_id:String):
	print('new level %s' % level_id)
	GM.stop()
	UI.fade(0)
	clear()
	Map._last_fov_center = -Vector2.ONE
	_level = Config.levels[level_id]
	var res = Map.generator().generate(world, _level)
	GM.spawn_player(res['start'])
	var query = Map.query().all()
	var p_len = len(_level.get('programs', []))
	if p_len != 0:
		print('spawning default %d' % p_len)
		for p in range(p_len):
			GM.spawn_at(_level['programs'][p], query.pop_random(true).grid_position)
		var programs_to_spawn = int(res['emtpy_cells'] / 16) - p_len
		print('spawning additional %d' % programs_to_spawn)
		for p in range(programs_to_spawn):
			var pid = _level['programs'][randi() % p_len]
			GM.spawn_at(pid, query.pop_random(true).grid_position)
	p_len = len(_level.get('threats', []))
	if p_len != 0:
		print('spawning default %d' % p_len)
		for p in range(p_len):
			GM.spawn_at(_level['threats'][p], query.pop_random(true).grid_position)
		var threats_to_spawn = int(res['emtpy_cells'] / 16) - p_len
		print('spawning additional %d' % threats_to_spawn)
		for p in range(threats_to_spawn):
			var pid = _level['threats'][randi() % p_len]
			GM.spawn_at(pid, query.pop_random(true).grid_position)
	if 'next' in _level:
		var ending = GM.spawn_at('directory_pointer', res['end'])
		ending.meta['value'] = _level['next']
		GM.spawn_at('compiler', res['compiler'])
	UI.show_message('> cd %s\n> %s' %[level_id.to_upper(), _level['description']])
#	for pointer in res.get('pointers', []):
#		GM.spawn_at('pointer', pointer[0]).meta['value'] = pointer[1]
#		GM.spawn_at('pointer', pointer[1]).meta['value'] = pointer[0]
	UI.update_integrity()
#	GM.resume(0.5)


func kill(entity:Entity, force:bool=false):
	if entity == player and !force:
		UI.death()
	else:
		var location = entity.grid_position
		var res = {}
		for t in entity._traits:
			get_trait(t).on_death(entity, res)
		if !'keep_alive' in res:
			if entity.is_character() and entity.faction == Entity.Faction.ENEMY:
				_threats_count -= 1
			Map.at(entity.grid_position).move_out(entity)
			_actors.erase(entity)
			world.remove_child(entity)
			if _actor_index >= len(_actors):
				_actor_index = 0
			if _threats_count == 0 and 'is_last' in _level:
				GM.stop(State.UI_PAUSE)
				yield(get_tree().create_timer(3.0), "timeout")
				var ew = GM.spawn_at('evilware', location)
				var fx = TeleportFx.instance()
				ew.add_child(fx)
				fx.emitting = true
				GM.resume_play()
		if entity == player:
			player = null


func remove_trait(entity:Entity, trait_id:String):
	entity._traits.erase(trait_id)


func resume(delay:float=0.0):
	if state == State.PAUSE:
		if delay > 0.0:
			yield(get_tree().create_timer(delay), "timeout")
#		print("Resumed")
		state = State.PLAY


func resume_play():
	state = State.PLAY


func set_player(value:Node2D):
	player = value


func set_world(value:Node):
	world = value


func shake(times:int=1) -> Node:
	var tween = Tween.new()
	var duration = 0.05
	var size = Vector2(4, 0)
	var delay = 0
	for i in times:
		tween.interpolate_property(world, 'position', Vector2.ZERO, size, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
		delay += duration
		tween.interpolate_property(world, 'position', size, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
		delay += duration
		size *= 1
	world.add_child(tween)
	tween.start()
	return self


func spawn_at(template_id:String, coords:Vector2) -> Entity:
	var res = null
	if template_id in Config.templates:
		var template = Config.templates[template_id]
		res = template['res'].instance().initialize(template)
#		print('spawning %s' % template_id)
		world.add_child(res)
		teleport(res, coords)
		if res.is_character():
			_actors.append(res)
#			print('added to _actors')
			if res.faction == Entity.Faction.ENEMY:
				_threats_count += 1
		else:
#			print('added to _objects')
			_objects.append(res)
		res.meta['name'] = template_id
	return res


func spawn_player(coords:Vector2) -> Entity:
	if player:
		teleport(player, coords)
		return player
	else:
		player = spawn_at('player', coords)
		player.self_modulate = Config.COLOR_OBJECT
	player.meta['name'] = 'Antivirus'
	Map.update_fov(player.grid_position)
	return player


func stop(new_state=State.PAUSE):
	if state == State.PLAY or new_state == State.UI_PAUSE:
		state = new_state
#		print("Stopped")


func teleport(entity:Entity, coords:Vector2, animate:bool=false):
	var old_cell = Map.at(entity.grid_position)
	var cell = Map.at(coords)
	if cell != Map.INVALID_CELL:
		if old_cell != Map.INVALID_CELL:
			old_cell.move_out(entity)
		entity.grid_position = coords
		cell.move_in(entity)
		if animate:
			var fx = TeleportFx.instance()
			entity.add_child(fx)
			fx.emitting = true
			yield(get_tree().create_timer(10.0), "timeout")
			fx.queue_free()
#
#
#func tick():
#	var done = false
#	var actor = _actors[_actor_index]
#	while !done:
#		if actor.is_idle() and state == State.PLAY and actor.run():
#			_actor_index = (_actor_index + 1) % len(_actors)
#			actor = _actors[_actor_index]
#		else:
#			done = true


func try_action(action_id:String, actor:Entity, params:Dictionary) -> bool:
	var action = _actions.get_node(action_id)
	if action:
		return action.attempt(actor, params)
	else:
		return false
