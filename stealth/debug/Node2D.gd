extends Node2D

var noise = OpenSimplexNoise.new()
var noise_texture = NoiseTexture.new()

# Various noise parameters.
var min_noise = -1
var max_noise = 1
var bruh: float
# Are we using a NoiseTexture instead?
# Noise textures automatically grab and apply the noise data to an ImageTexture, instead of manually.
const use_noise_texture = true

func _physics_process(delta):
	bruh += delta
	$TextureRect.texture.noise.seed = bruh
# Called when the node enters the scene tree for the first time.
#func _ready():no
#	# Set up noise with basic info.
#	noise.seed = 99
#	noise.lacunarity = 99
#	noise.octaves = 99
#	noise.period = 99
#	noise.persistence = 99
#
#	# Render the noise.
#	_refresh_noise_images()
#
#	# Do we need to set up a noise texture?
#	if use_noise_texture:
#		noise_texture.noise = noise
#		$TextureRect.texture = noise_texture
#
#
#func _refresh_noise_images():
#	# Adjust min/max for shader.
#	var _min = (min_noise + 1) / 2
#	var _max = (max_noise + 1) / 2
#	var _material = $TextureRect.material
#	_material.set_shader_param("min_value", _min)
#	_material.set_shader_param("max_value", _max)
