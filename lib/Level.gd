extends Node2D

var pointsToDraw = []

func _ready():
    pass

func addPointToDraw(point, radius=1.0, color='#00f'):
    pointsToDraw.append([point, radius, color])
    update()

func _draw():
    for ptd in pointsToDraw:
        draw_circle(ptd[0], ptd[1], ptd[2])
    pointsToDraw = []

func _process(delta):
    _process_paths(delta)

func _process_paths(delta):
    for path in $Paths.get_children():
        for follow in path.get_children():
            if not follow.get_child_count():
                continue
            var entity = follow.get_child(0)
            follow.offset += (entity.get('speed') if entity.get('speed') else 25) * delta
