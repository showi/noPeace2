extends Node2D

func _ready():
    print('airPath: ', $AirPath.get_path())

func getAirPaths():
    return $AirPath.get_children()

func addPointToDraw(point, radius=5.0, color='#faa'):
    print('level: ', point)
    $Navigation2D.addPointToDraw(point, radius, color)

func clearPointsToDraw():
    $Navigation2D.clearPointsToDraw()