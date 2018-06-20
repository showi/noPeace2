extends 'res://lib/BaseEnemy.gd'

onready var nav = get_node('/root/Game/LevelManager/Level/Navigation2D')
var navigationPath = null

var pointsToDraw = []

func detected(kind, entity):
    $WeaponSystem.setAutoFire(true)
    $WeaponSystem.immediateFire()
    if navigationPath:
        print('navigationPath already set')
        return
    update()
    navigationPath = nav.get_simple_path(
        entity.get_global_position(),
        get_global_position()
    )

func loose(kind, entity):
    $WeaponSystem.setAutoFire(false)
    navigationPath = null
    pointsToDraw = []

func _draw():
    if navigationPath and navigationPath.size():
        for point in navigationPath:
            draw_circle(to_local(point), 10, Color('#f00'))
    for point in pointsToDraw:
        draw_line(Vector2(0, 0), to_local(point), Color('#0f0'), 10)

func _process(delta):
    ._process(delta)
    if navigationPath and navigationPath.size():
        var point = navigationPath[0]
        var gpos = get_global_position()
        var distance = (point - position).length()
        var uv = Vector2(0, -1).rotated(rotation).normalized()
        var angle = uv.angle_to(point.normalized())
        update()
        rotation += angle
        var velocity = uv.normalized() * (speed + 100)
        linear_velocity =  velocity
