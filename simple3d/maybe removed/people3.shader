shader_type spatial;
render_mode unshaded;

uniform vec3 light_pos;
uniform float offset;
uniform float colors;

void fragment(){
	float dot_product = dot(normalize(NORMAL), normalize(light_pos));
	dot_product += offset;
	dot_product = round(dot_product * colors) / colors;
	ALBEDO = vec3(dot_product);
}