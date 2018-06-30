extends Node2D

func _ready():
    print('airPath: ', $AirPath.get_path())
    addObstaclesToNavigation()

func getAirPaths():
    return $AirPath.get_children()

func addPointToDraw(point, radius=5.0, color='#faa'):
    $Navigation2D.addPointToDraw(point, radius, color)

func clearPointsToDraw():
    $Navigation2D.clearPointsToDraw()

func addObstaclesToNavigation():
    var nav = $Navigation2D/NavigationPolygonInstance
    for obstacle in $Obstacles.get_children():
        var polygon = obstacle.get_node('Polygon2D').polygon
        nav.navpoly.add_outline(polygon)
    nav.navpoly.make_polygons_from_outlines()
    nav.enabled = false
    nav.enabled = true