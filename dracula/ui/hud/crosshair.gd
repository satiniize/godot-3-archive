extends TextureRect

func _draw():
	var points = []
	var sides = 4
	var length = 8
	var offset = 6
	var color = Color.red
	var outline_color = Color.black
	var thickness = 2
	var center_dot_diameter = 2
	var outline_thickness = 1
	draw_circle(Vector2.ZERO, center_dot_diameter / 2 + outline_thickness, outline_color)
	draw_circle(Vector2.ZERO, center_dot_diameter / 2, color)
	for i in range(sides):
		var radians = float(i) / float(sides) * 2*PI
		points.append(Vector2(sin(radians), -cos(radians)))
	for i in range(sides):
		draw_line(points[i]*(offset - outline_thickness), points[i]*(length + offset + outline_thickness), outline_color, thickness + 2*outline_thickness)
		draw_line(points[i]*offset, points[i]*(length + offset), color, thickness)

func _process(delta):
	update()
