extends Action


var Fx = preload("res://Actions/AttackFx.tscn")


func attack(actor:Entity, target:Entity):
	var skill = GM.get_skill(actor.mind.crack)
	var dam = skill.get_damage(actor)
	var minimum = dam.get('min', 0)
	var maximum = dam.get('max', 4)
	var atk = minimum + randi() % (maximum - minimum) - target.robustness
	if atk > 0:
		target.add_child(Fx.instance())
	yield(actor.animate_attack(target), 'tween_all_completed')
	if 'dead' in GM.damage(actor, target, atk, skill) and actor == GM.player:
		print('player kill, adding bits')
		actor.meta['bits'] += target.meta.get('bits', 0)
	GM.resume()


func attempt(actor:Entity, params:Dictionary) -> bool:
	var res = false
	var target = params.get('target', null)
	if target:
		GM.stop()
		attack(actor, target)
		res = true
	return res
