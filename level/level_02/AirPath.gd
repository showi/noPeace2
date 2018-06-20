extends Node2D

func _process(delta):
    for path in get_children():
        for follow in path.get_children():
            if not follow.get_child_count():
                continue
            var entity = follow.get_child(0)
            follow.offset += (entity.get('speed') if entity.get('speed') else 25) * delta
