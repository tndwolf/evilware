extends Node2D


func _ready():
	UI.initialize(get_node("UiLayer"))
	GM.world = $World
	GM.goto_level('/test')
	GM.spawn_at('compiler', Vector2(15, 16))
	GM.spawn_at('bug', Vector2(15, 15))
#	GM.spawn_at('file', Vector2(14, 14))
#	GM.spawn_at('program', Vector2(15, 14))
	UI.update_integrity()
#	GM.add_trait(GM.player, 'Weakened')
#	GM.add_trait(GM.player, 'Stunned')
#	GM.spawn_at('directory_pointer', Vector2(3, 3))
#	GM.spawn_at('data', Vector2(2, 3))
#	UI.switch_to_compiler()


func _on_RespawnButton_pressed():
	UI.death_ui.visible = false
	UI.initialize(get_node("UiLayer"))
	GM.world = $World
	GM.goto_level('/test')
	UI.update_integrity()
