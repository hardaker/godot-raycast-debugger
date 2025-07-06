# godot-raycast-debugger

About: A godot debugging class for visualizing raycast results for easier debugging.

Purpose: Don't you hate it when you're trying to debug a tricky problem with raycasting,
which is hard enough to understand in the first place, and you have no clue where the
problem is other than "things seem to be missing each other".  This class comes to the
rescue and provides an easier raycast API complete with optional visualization of both
rays being cast and what those rays are coming into contact with.  It graphically 
draws green lines from the ray source to destination for every ray cast since the 
last time the screen was rendered.  If the ray produces a collision, then a second
red line will be drawn from source to the target that got hit.

# Usage

1. Copy the raycast_debugger.gd script to your project's source code.

2. Initialize the class as a child of the class you want to draw:

3. use the `.test_collision(source, dest, ignore_objects)` API for casting a ray,
which will return a collision object or `none`.

4. Set the object's `enableDebugging` flag to `true` to have the screen light up with
cast and detection rays.

# Example video

TBD
