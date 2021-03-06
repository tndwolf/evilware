extends Node
class_name MapGenerator


var CellFactory = preload("res://World/Cell.tscn")
var map = null
var world = null


func _add_terminal(params:Dictionary, to_dig:Array):
	var start = params.get('start', Vector2.ZERO)
	var end = params.get('end', Vector2.ZERO)
	var done = false
	var i = 0
	var cells = Array(to_dig)
	cells.shuffle()
	while !done:
		var coords = cells[i]
		if coords != start and coords != end:
			return coords
		i += 1
	return Vector2.ZERO


func _dig(params:Dictionary={}) -> Dictionary:
	var dig = params['dig']
	var size = params['size']
	var start = null
	var end = null
	var to_dig = random_walk(size/2, dig, Map._area)
	params['emtpy_cells'] = dig
	for coords in to_dig:
		Map.at(coords).cell_type = Cell.Type.FLOOR
		if !start:
			start = coords
		elif !end:
			if start.distance_to(coords) > dig / 3:
				end = coords
	if !end:
		end = to_dig[len(to_dig)-1]
	make_islands(params, size)
	params['start'] = start
	params['end'] = end
	params['compiler'] = _add_terminal(params, to_dig)
	return params


func clear(default_cell_type:int) -> MapGenerator:
	var start_time = OS.get_ticks_msec()
	for cell in map._cells:
		for e in cell.entities():
			cell.move_out(e)
		cell.cell_type = default_cell_type
		cell.corruption = Cell.Corruption.NONE
		cell.show()
		cell.in_los = false
		cell.corruption_resist = 0
#	print("Clear time: ", OS.get_ticks_msec() - start_time)
	return self


func _dig_around(coords:Vector2):
	for cell in Map.query().burst(coords, 1).collect():
		cell.cell_type = Cell.Type.FLOOR


func generate(world:Node2D, params:Dictionary={}) -> Dictionary:
	var res = params.duplicate(true)
	self.world = world
	var def_type = params.get('default_cell_type', Cell.Type.ABYSS)
	var pointers = params.get('pointers', 2)
	var size = params.get('size', Vector2(16, 16))
	_resize(size)
	clear(def_type)
	if 'dig' in params:
		res = _dig(res)
	_dig_around(res['end'])
	_dig_around(res['compiler'])
	Map.calculate_astar()
#	print(res)
	return res


func initialize(map) -> MapGenerator:
	self.map = map
	return self


func make_islands(params:Dictionary, size:Vector2):
	var how_many = params.get('islands', 0)
	var island_type = params.get('islands_type', Cell.Type.ABYSS)
	for _i in range(how_many):
		for coords in random_walk(size/2, 32, Map._area):
			var cell = Map.at(coords)
			if cell.cell_type != Cell.Type.FLOOR:
				cell.cell_type = island_type


func _make_pointers(res:Dictionary) -> Dictionary:
	var query = Map.query().pair(9).collect()
	if !'pointers' in res:
		res['pointers'] = []
	res['pointers'].append(query)
	return res


# Returns a random point within a rectangular area
static func random_point(within:Rect2)->Vector2:
	return Vector2(
		within.position.x + randi() % int(within.size.x),
		within.position.y + randi() % int(within.size.y))


# Returns a list of Vector2 starting from a point.
# The walk follows the four cardinal directions and each point is counted only
# once, ensuring that the number of steps is exactly as expected
func random_walk(from:Vector2, steps:int, constraints:Rect2=Rect2(0, 0, INF, INF)) -> PoolVector2Array:
	var x = int(from.x)
	var y = int(from.y)
	var dx = 0
	var dy = 0
	var res = PoolVector2Array([from])
	var count = 0
	while count < steps:
		match randi() % 4:
			0:
				dx = 1; dy = 0
			1:
				dx = -1; dy = 0
			2:
				dx = 0; dy = 1
			3:
				dx = 0; dy = -1
		var next = Vector2(x + dx, y + dy)
		if !constraints.has_point(next):
			continue
		if !(next in res):
			count += 1
			res.append(next)
		x += dx
		y += dy
	return res


func _resize(size:Vector2) -> MapGenerator:
	var new_count = size.x * size.y
	var cell_count = len(map._cells)
	var to_add = new_count - cell_count
	var start_time = OS.get_ticks_msec()
	if to_add > 0:
		for _i in range(to_add):
			var cell = CellFactory.instance()
			map._cells.append(cell)
			world.add_child(cell)
#	print("Resize time: ", OS.get_ticks_msec() - start_time)
	start_time = OS.get_ticks_msec()
	map._area = Rect2(Vector2.ZERO, size)
	for y in range(size.y):
		for x in range(size.x):
			var coords = Vector2(x, y)
			map.at(coords).grid_position = coords
#	print("Reset time: ", OS.get_ticks_msec() - start_time)
	return self
