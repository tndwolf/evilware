extends Node


enum State {
	PLAY,
	PAUSE
}


var _actions = preload("res://Actions/Actions.tscn").instance()
var _actors = []
var _actor_index = 0
var _level = {}
var _objects = []
var player = null setget set_player, get_player
var _skills = preload("res://Skills/Skills.tscn").instance()
var state = State.PLAY
var _traits = preload("res://Traits/Traits.tscn").instance()
var world = null setget set_world, get_world


func _unhandled_input(event):
	if event.is_action_pressed("next_hack"):
		player.mind.next_hack()


func add_trait(entity:Entity, trait_id:String) -> Entity:
	if !trait_id in entity._traits:
		var trait = get_trait(trait_id)
		if trait:
			entity._traits.append(trait_id)
			trait.on_added(entity)
	return entity


func clear() -> Node:
	for entity in _objects:
		Map.at(entity.grid_position).move_out(entity)
		_objects.erase(entity)
		world.remove_child(entity)
	_objects.clear()
	for entity in _actors:
		if entity != player:
			Map.at(entity.grid_position).move_out(entity)
			_actors.erase(entity)
			world.remove_child(entity)
	_actors.clear()
	_actor_index = 0
	if player:
		_actors.append(player)
	return self


func damage(actor:Entity, target:Entity, value:int, skill:Skill, params:Dictionary={}) -> Dictionary:
	print('dealing %d damage to %s' % [value, target])
	if value > 0:
		target.integrity -= value
		if skill != null:
			skill.on_damage(actor, target, params)
	return params


func flash(color:Color) -> Node:
	return self


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
	return res if res else Trait.new()


func get_world() -> Node:
	return world


func goto_level(level_id:String):
	print('new level %s' % level_id)
	GM.stop()
	clear()
	Map._last_fov_center = -Vector2.ONE
	_level = Config.levels[level_id]
	var res = Map.generator().generate(world, _level)
	GM.spawn_player(res['start'])
	if 'next' in _level:
		var ending = GM.spawn_at('directory_pointer', res['end'])
		ending.meta['value'] = _level['next']
#	for pointer in res.get('pointers', []):
#		GM.spawn_at('pointer', pointer[0]).meta['value'] = pointer[1]
#		GM.spawn_at('pointer', pointer[1]).meta['value'] = pointer[0]
	GM.resume(0.5)


func kill(entity:Entity):
	if entity == player:
		pass
	else:
		var res = {}
		for t in entity._traits:
			get_trait(t).on_death(entity, res)
		if !'keep_alive' in res:
			if _actors[_actor_index] == entity:
				_actor_index = (_actor_index) % (len(_actors) - 1)
			Map.at(entity.grid_position).move_out(entity)
			_actors.erase(entity)
			world.remove_child(entity)


func resume(delay:float=0.0):
	if delay > 0.0:
		yield(get_tree().create_timer(delay), "timeout")
	state = State.PLAY


func set_player(value:Node2D):
	player = value


func set_world(value:Node):
	world = value


func shake(times:int) -> Node:
	return self


func spawn_at(template_id:String, coords:Vector2) -> Entity:
	var res = null
	if template_id in Config.templates:
		var template = Config.templates[template_id]
		res = template['res'].instance().initialize(template)
		world.add_child(res)
		teleport(res, coords)
		if res.is_character():
			_actors.append(res)
		else:
			_objects.append(res)
	return res


func spawn_player(coords:Vector2) -> Entity:
	if player:
		teleport(player, coords)
		return player
	else:
		player = spawn_at('player', coords)
	Map.update_fov(player.grid_position)
	return player


func stop():
	state = State.PAUSE


func teleport(entity:Entity, coords:Vector2):
	var old_cell = Map.at(entity.grid_position)
	var cell = Map.at(coords)
	if cell != Map.INVALID_CELL:
		if old_cell != Map.INVALID_CELL:
			cell.move_out(entity)
		entity.grid_position = coords
		cell.move_in(entity)


func tick():
	var done = false
	var actor = _actors[_actor_index]
	while !done:
		if actor.is_idle() and state == State.PLAY and actor.run():
			_actor_index = (_actor_index + 1) % len(_actors)
			actor = _actors[_actor_index]
		else:
			done = true


func try_action(action_id:String, actor:Entity, params:Dictionary) -> bool:
	var action = _actions.get_node(action_id)
	if action:
		return action.attempt(actor, params)
	else:
		return false
