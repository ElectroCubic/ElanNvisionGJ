extends ParallaxBackground

var scrolling_speed = 150

func _process(delta):
	scroll_offset.x -= scrolling_speed * delta
