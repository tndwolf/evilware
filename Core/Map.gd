extends Node


var INVALID_CELL = Cell.new()


var _area = Rect2(Vector2.ZERO, Vector2.ZERO)
var _astar = AStar2D.new()
var _cells = []
var _cells_in_los = []
var _generator = MapGenerator.new()
var _last_fov_center = Vector2.ZERO
var _query = MapQuery.new()


func at(coords:Vector2) -> Cell:
	if _area.has_point(coords):
		return _cells[coords.x + coords.y * _area.size.x]
	else:
		return INVALID_CELL


func calculate_astar(include_diagonals=true) -> Node:
	_astar.clear()
	var w = width()
	var h = height()
	for y in range(h):
		for x in range(w):
			var i = x + y * w
			_astar.add_point(i, _cells[i].grid_position)
			if !_cells[i].blocks_movement:
				if x > 0 and !_cells[i-1].blocks_movement:
					_astar.connect_points(i, i-1)
				if y > 0 and !_cells[i-w].blocks_movement:
					_astar.connect_points(i, i-w)
				if include_diagonals and x > 0 and y > 0:
					if !_cells[i-w-1].blocks_movement:
						_astar.connect_points(i, i-w-1)
					if !_cells[i-w].blocks_movement and !_cells[i-1].blocks_movement:
						_astar.connect_points(i-1, i-w)
	return self


func calculate_los(from:Vector2, to:Vector2)->bool:
	var dx = abs(from.x - to.x)
	var dy = abs(from.y - to.y)
	var sx = -1 if from.x > to.x else 1
	var sy = -1 if from.y > to.y else 1
	var x = from.x
	var y = from.y
	if dx > dy:
		var err = dx / 2.0
		while x != to.x:
			if at(Vector2(x, y)).blocks_los(): return false
			err -= dy
			if err < 0:
				y += sy;
				err += dx;
			x += sx
	else:
		var err = dy / 2.0
		while y != to.y:
			if at(Vector2(x, y)).blocks_los(): return false
			err -= dx
			if err < 0:
				x += sx;
				err += dy;
			y += sy
	return true


func generator():
	return _generator.initialize(self)


func height() -> int:
	return int(_area.size.y)


func in_los(coords:Vector2) -> bool:
	return at(coords).in_los


func path_to(from:Vector2, to:Vector2)->PoolVector2Array:
	var from_id = from.x + from.y * width()
	var to_id = to.x + to.y * width()
	return _astar.get_point_path(from_id, to_id)


func query():
	return _query.initialize(self)


func update_fov(center:Vector2, radius:int=6) -> Node:
	if center == _last_fov_center:
		return self
	_last_fov_center = center
	for cell in _cells_in_los:
		cell.in_los = false
	_cells_in_los.clear()
	var sq_distance = radius * radius
	for y in range(center.y - radius, center.y + radius):
		for x in range(center.x - radius, center.x + radius):
			var coords = Vector2(x, y)
			var cell = at(coords)
			if cell != INVALID_CELL:
				cell.in_los = coords.distance_squared_to(center) < sq_distance and calculate_los(center, coords)
				_cells_in_los.append(cell)
	return self


func width() -> int:
	return int(_area.size.x)
