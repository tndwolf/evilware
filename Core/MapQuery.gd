extends Node
class_name MapQuery


var _cells = []
var map = null


func add(coords:Vector2) -> MapQuery:
	var cell = Map.at(coords)
	if cell != Map.INVALID_CELL:
		_cells.append(cell)
	return self


func all() -> MapQuery:
	_cells.clear()
	for y in range(0, map.height()):
		for x in range(0, map.width()):
			_cells.append(map.at(Vector2(x, y)))
	return self


func burst(from:Vector2, size:int) -> MapQuery:
	_cells.clear()
	for y in range(from.y - size, from.y + size + 1):
		for x in range(from.x - size, from.x + size + 1):
			var cell = Map.at(Vector2(x, y))
			if cell != Map.INVALID_CELL:
				_cells.append(cell)
	return self


func clear() -> MapQuery:
	_cells.clear()
	return self


func collect(only_free:bool=false) -> Array:
	if only_free:
		var res = []
		for cell in _cells:
			if _is_valid(cell):
				res.append(cell)
		return res
	else:
		return _cells


func first(only_free:bool=false) -> Cell:
	if only_free:
		for cell in _cells:
			if _is_valid(cell):
				return cell
	return null if len(_cells) == 0 else _cells[0]


func fov() -> MapQuery:
	clear()
	for cell in Map._cells_in_los:
		_cells.append(cell)
	return self


func initialize(map) -> MapQuery:
	_cells.clear()
	self.map = map
	return self


func in_los() -> MapQuery:
	var res = []
	for cell in _cells:
		if cell.in_los:
			res.append(cell)
	_cells = res
	return self


func _is_valid(cell:Cell) -> bool:
	return cell.is_empty() and cell.is_walkable()


func pair(distance:float=1.0) -> MapQuery:
	_cells.clear()
	var iter = 0
	var sq_distance = distance * distance
	var cell1 = null
	var cell2 = null
	while iter < 10000:
		var in_iter = 0
		cell1 = _random()
		while !_is_valid(cell1) and in_iter < 10000:
			cell1 = _random()
			in_iter += 1
		in_iter = 0
		cell2 = _random()
		while !_is_valid(cell2) and in_iter < 10000:
			cell2 = _random()
			in_iter += 1
		if cell1.grid_position.distance_squared_to(cell2.grid_position) > sq_distance:
			break
		iter += 1
	_cells = [cell1, cell2]
	return self


func pop_first(only_free:bool=false) -> Cell:
	var res = first(only_free)
	if res:
		_cells.pop_front()
	return res


func pop_random(only_free:bool=false) -> Cell:
	var res = random(only_free)
	if res:
		_cells.erase(res)
	return res


func _random() -> Cell:
	return map.at(Vector2(
		randi() % map.width(),
		randi() % map.height()
	))


func random(only_free:bool=false) -> Cell:
	_cells.shuffle()
	if !only_free:
		return null if len(_cells) == 0 else _cells[0]
	else:
		for cell in _cells:
			if _is_valid(cell):
				return cell
	return null


func random_empty(how_many:int=1) -> MapQuery:
	var res = []
	var prev_cell = null
	while how_many > 0:
		var cell = _random()
		if _is_valid(cell):
			res.append(cell)
			how_many -= 1
	_cells = res
	return self
