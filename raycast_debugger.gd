class_name RayCastDebugger2D
extends RigidBody2D
## A class for debugging 2D raycast usage and problems
##
## This class can be used to initiate 2D raycasts that will
## return the collision object from a intersect_ray() result,
## along with optionally displaying a green line on the screen
## showing the ray path, along with a thinner red line when
## a collision is detected.  This code is MIT licensed so you
## may reuse it fairly freely (see the LICENSE file for details).
## You will likely need to modify it to suit how you specifically
## use raycasting.  Some options are available below in the
## intersect_ray() call, but only limited options.

## Enable visual debugging cast and collision lines.
@export var enableDebugging: bool = false

## The color of the raycast line.
@export var cast_color: Color = Color.GREEN

## The color of the line that is displayed upon a detected collision.
@export var hit_color: Color = Color.RED

var the_world_state: PhysicsDirectSpaceState2D = null

var cast_lines: Array[Line2D] = []
var hit_lines: Array[Line2D] = []
var line_count: int = 0

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

	# If this is the first call since a screen reset,
	# turn off visibilty for all past lines
	if line_count == 0:
		for i in range(len(cast_lines)):
			cast_lines[i].visible = false
			hit_lines[i].visible = false

	# get our world space state and set up our ray query
	var world_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = exclude
	query.collide_with_areas = collide_with_areas

	# perform the actually raycast
	var collision_result = world_state.intersect_ray(query)

	# when debugging is enabled, draw the related lines on the screen
	if enableDebugging:
		visible = true

		# draw the cast line
		var cast_line: Line2D
		var hit_line: Line2D

		if len(cast_lines) <= line_count:
			# If this is a new cast without a related past Line2D,
			# create and store a new one for reuse in future raycasts.
			cast_line = create_line()
			cast_lines.append(cast_line)

			hit_line = create_line()
			hit_lines.append(hit_line)
		else:
			# Use a previously cached version of the related Line2D
			cast_line = cast_lines[line_count]
			hit_line = hit_lines[line_count]
			
		# set the (GREEN) line vector coordinates
		cast_line.visible = true
		cast_line.global_position = Vector2(0, 0)
		cast_line.points = PackedVector2Array([from, to])

		if collision_result:
			# if a collision was detected, set the collision (RED)
			# line coordinates
			hit_line.global_position = Vector2(0, 0)
			hit_line.points = PackedVector2Array([from, collision_result.position])
			hit_line.visible = true
		else:
			# if the raycast did not collide, turn off the collision line 
			hit_line.visible = false

		line_count += 1

	else:
		# when not debugging, turn off our visibility entirely
		visible = false

	# return the results of the raycast itself
	return collision_result
