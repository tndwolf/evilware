extends Timer


export var cur_frame = 24
export var next_frame = 25


func _on_timeout():
	var current = cur_frame
	get_parent().frame = next_frame
	cur_frame = next_frame
	next_frame = current
	wait_time = randf() * 3.0 + 1.0
