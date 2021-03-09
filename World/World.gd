extends Node2D


func _ready():
	GM.world = self
	GM.goto_level('/test')
	GM.spawn_at('adware', Vector2(13, 13))
#	GM.spawn_at('directory_pointer', Vector2(3, 3))
#	GM.spawn_at('data', Vector2(2, 3))


func _process(delta):
	GM.tick()
