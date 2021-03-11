extends Node2D


func _ready():
	UI.initialize(get_node("UiLayer"))
	GM.world = $World
	GM.goto_level('/test')
	GM.spawn_at('bug', Vector2(13, 13))
#	GM.spawn_at('file', Vector2(14, 14))
#	GM.spawn_at('program', Vector2(15, 14))
	UI.integrity_bar.maximum = GM.player._max_integrity
	UI.integrity_bar.value = GM.player.integrity
#	GM.add_trait(GM.player, 'Weakened')
#	GM.add_trait(GM.player, 'Stunned')
#	GM.spawn_at('directory_pointer', Vector2(3, 3))
#	GM.spawn_at('data', Vector2(2, 3))
