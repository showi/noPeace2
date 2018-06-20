extends Navigation2D

var pointsToDraw = []

func addPointToDraw(point, radius=5.0, color='#faa'):
    pointsToDraw.append([point, radius, color])
    update()

func clearPointsToDraw():
    pointsToDraw = []
    update()

func _draw():
    for pd in pointsToDraw:
        draw_circle(pd[0], pd[1], pd[2])