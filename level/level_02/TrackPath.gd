extends PathFollow2D

func _process(delta):
    unit_offset += delta * 0.01
