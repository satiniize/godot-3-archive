tool
extends Node2D

var drawpos = Vector2.ZERO
export(int) var magazineSize
export(int, 0, 100) var bulletCount
export(float, 0.0, 1.0) var offset
export(bool) var debug
export(float) var RPS
var timer := 0.0

func _physics_process(delta):
	if debug:
		get_parent().get_node("recoilPattern/recoilPatternFollow").offset = 1.0 / float(magazineSize) * float(bulletCount) * get_parent().get_node("recoilPattern").curve.get_baked_length() * 0.999
		drawpos = get_parent().get_node("recoilPattern/recoilPatternFollow").global_position
		var minmax = get_parent().getPoolVector2ArrayYVectorMinMax(
			get_parent().get_node("recoilPattern").curve.get_baked_points()
		)
		var minvar = minmax[0]
		var maxvar = minmax[1]
		var dist = maxvar - minvar
		$debugSprite.position = drawpos
		if timer > 1.0 / RPS:
			bulletCount += 1
			bulletCount = bulletCount % (magazineSize + 1)
			timer = 0.0
		timer += delta
