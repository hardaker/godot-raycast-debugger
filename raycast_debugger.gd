class_name RayCastDebugger2D
extends RigidBody2D

@export var enableDebugging: bool = false
@export var cast_color: Color = Color.GREEN
@export var hit_color: Color = Color.RED

var the_world_state: PhysicsDirectSpaceState2D = null

var cast_lines: Array[Line2D] = []
var hit_lines: Array[Line2D] = []
var line_count: int = 0

var last_from = null
var last_to = null

enum LineType { PROJECTION, HIT_LINE };

func create_line(line_type: LineType = LineType.PROJECTION) -> Line2D:
	"""Creates a Line2D object for displaying on the screen"""
	# create our new line child
	var line = Line2D.new()
	line.global_position = Vector2(0, 0)
	
	# set the psecifica colors
	if line_type == LineType.PROJECTION:
		line.width = 5
		line.z_index = 999
		line.default_color = Color.GREEN
	else:
		line.width = 3
		line.z_index = 1000
		line.default_color = Color.RED
	add_child(line)
	return line	

func _process(_delta: float) -> void:
	"""Per-frame process routine that merely resets our line usage counter."""
	line_count = 0

func intersect_ray(
		from: Vector2, to: Vector2, exclude: Array = [], collide_with_areas: bool = true
		):
	"""Test a collision from a starting to ending vector and memorize the ray."""

	if line_count == 0:
		for i in range(len(cast_lines)):
			cast_lines[i].visible = false
			hit_lines[i].visible = false

	var world_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = exclude
	query.collide_with_areas = collide_with_areas

	var result = world_state.intersect_ray(query)

	if enableDebugging:
		visible = true

		# draw the cast line
		var cast_line: Line2D
		var hit_line: Line2D
		if len(cast_lines) <= line_count:
			print("growing: " + str(line_count))
			# add a new line to the cast_lines array
			cast_line = create_line()
			cast_lines.append(cast_line)
			hit_line = create_line()
			hit_lines.append(hit_line)
		else:
			cast_line = cast_lines[line_count]
			hit_line = hit_lines[line_count]
			
		cast_line.visible = true
		cast_line.global_position = Vector2(0, 0)
		cast_line.points = PackedVector2Array([from, last_to])

		if result:
			print("hit something: " + str(result.collider))
			hit_line.global_position = Vector2(0, 0)
			hit_line.points = PackedVector2Array([from, result.position])
			hit_line.visible = true
		else:
			# print("hit nothing")
			hit_line.visible = false

		line_count += 1

	else:
		visible = false

	return result
