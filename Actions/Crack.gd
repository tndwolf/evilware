extends Action


var Fx = preload("res://Actions/AttackFx.tscn")


func attack(actor:Entity, target:Entity):
	var skill = GM.get_skill(actor.mind.crack)
	var dam = skill.get_damage(actor)
	var atk = calc_damage(actor, target, dam)
	if atk > 0:
		target.add_child(Fx.instance())
#		print('attacking with skill %s' % actor.mind.crack)
	yield(actor.animate_attack(target), 'tween_all_completed')
	if 'dead' in GM.damage(actor, target, atk, skill) and actor == GM.player:
		var bits = target.meta.get('bits', 0)
#		print('player kill, adding %d bits' % bits)
		actor.meta['bits'] += bits
		UI.update_bits()
	GM.resume()


func attempt(actor:Entity, params:Dictionary) -> bool:
	var res = false
	var target = params.get('target', null)
	if target:
		GM.stop()
		attack(actor, target)
		res = true
	return res


func calc_damage(actor:Entity, target:Entity, damage:Dictionary)->int:
	var soak = target.robustness - target.meta.get('weakened:amount', 0) - target.meta.get('corruption', 0)
	soak = clamp(soak, 0, 128)
	var weakened_amount = actor.meta.get('weakened:amount', 0) - actor.meta.get('corruption', 0)
	var minimum = damage.get('min', 0)
	var maximum = damage.get('max', 0)
	var res = minimum + randi() % (maximum - minimum)
	res = clamp(res - weakened_amount - soak, 0, 128)
	return res
