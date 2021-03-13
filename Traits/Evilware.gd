extends Trait


func on_added(entity:Entity, params:Dictionary={}):
	entity.robustness = 2


func on_round(entity:Entity):
	print(GM._threats_count)
	if GM._threats_count < 2 and randi() % 2 == 0:
		spawn(entity)
	if GM._threats_count < 5 and randi() % 4 == 0:
		spawn(entity)


func spawn(evilware:Entity):
	var cell = Map.query().burst(evilware.grid_position, 1).random(true)
	if cell and cell.is_empty():
		var new_gen = GM.spawn_at('rootkit', cell.grid_position)


func on_death(entity:Entity, params:Dictionary={}) -> Dictionary:
	GM.stop()
	UI.fade(0)
	UI.show_win("""As you strike your final and most Evil foe, the other malwares flee, leaving you battered but victorious.\nThe System is safe and your User smirks proudly: it is time for some improvements!\nTHANKS FOR PLAYING!""")
	return params
