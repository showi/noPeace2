extends Node

var version = '0.0.10'
var title = 'noPeace'

func _ready():
    print('libCommon loaded')

func _init():
    print('CollisionLayer: ', CollisionLayer)

func getLevelPath(levelName):
    return 'res://level/' + levelName + '/LevelContainer.tscn'

func getLevel():
    return get_node('/root/Game/LevelManager/LevelContainer')

func getLevelManager():
    return get_node('/root/Game/LevelManager')

func getLevelDefaultPath():
    return 'res://lib/LevelDefault.tscn'

func getLevelDefault():
    return get_node('/root/Game/LevelManager/LevelDefault')

func getPlayerPath():
    return 'res://player/Player.tscn'

func getPlayer():
    return get_node('/root/Game/LevelManager/LevelContainer/Player')

func getScreenSize():
    return get_node('/root').size

func getLevelEntity(partialPath):
    return get_node('/root/Game/LevelManager/LevelContainer/' + partialPath)

func getResource(kind, resourceName):
    return load('res://' + kind + '/' + resourceName + '/' + kind.capitalize() + '.tscn')

static func getEntityKind(entity):
    if not entity:
        return 'NoEntity'
    if entity.has_meta('entityKind'):
        return entity.get_meta('entityKind')
    return 'Unknown'

enum CollisionLayer {
    Ground =          0
    Enemy =           1,
    Detection =       2,
    Player =          3
    BulletPlayer =    4,
    BulletEnemy =     5,
    Wall =            6,
}

const stats = {
    'player': {
       'score': 0
   }
}

func addPlayerStat(kind, value):
    stats['player'][kind] += value

func getPlayerStat(kind):
    return stats['player'][kind]

static func hit(src, entity):
    var kind = getEntityKind(entity)
    print('kind :', kind)
    if kind == 'Ammo':
        var shooter = entity.getShooter()
        var shooterKind = getEntityKind(shooter)
        if shooterKind != kind:
            src.setLife(src.life - entity.hitDamage)
            entity.kill()

func kill(entity, killAnimation):
    entity.hide()
    var animation = killAnimation.instance()
    animation.set_scale(Vector2(4, 4))
    animation.set_position(entity.get_global_position())
    get_node('/root/Game/LevelManager/LevelContainer').add_child(animation)

static func setLife(entity, value):
    if entity.life == value:
        return
    entity.life = value
    entity.emit_signal('lifeChanged', value)
    if entity.life <= 0:
        entity.kill()

static func makePathOffset(path, point):
    var total = 0
    var points = path.curve.get_baked_points()
    var count = points.size()
    var idx = 0
    while idx + 1 < count:
        total += (points[idx + 1] - points[idx]).length()
        if points[idx + 1] == point:
            break
        idx += 1
    return total

static func getClosestPointInPaths(entity, paths):
    var selected
    var minDistance
    for path in paths:
        var idx = 0
        for point in path.curve.get_baked_points():
            var distance = (path.to_global(point) - entity.get_global_position()).length()
            if minDistance == null or distance < minDistance:
                selected = [path, point, distance]
                minDistance = distance
    return [selected[0], selected[1], selected[2], makePathOffset(selected[0], selected[1])]

static func attachEntityToPath(entity, path, offset):
    entity.linear_velocity = Vector2(0, 0)
    entity.position = Vector2(0, 0)
    entity.rotation = PI / 2
    var follow = PathFollow2D.new()
    follow.set_rotate(true)
    entity.get_parent().remove_child(entity)
    follow.add_child(entity)
    follow.set_offset(offset)
    path.add_child(follow)
    return follow

static func detachEntityFromTrack(entity, track):
    var level = track.get_node('/root/Game/LevelManager/LevelContainer')
    var transform = entity.get_global_transform()
    track.remove_child(entity)
    level.add_child(entity)
    entity.set_global_transform(transform)

static func setObjectAttributes(obj, attributes):
    if not attributes:
        return
    for key in attributes.keys():
        obj.set(key, attributes[key])

static func getNavigationPath(entity, _targetPoint, navigation):
    var targetPoint = _targetPoint
    if typeof(_targetPoint) != TYPE_VECTOR2:
        targetPoint = _targetPoint.get_global_position()
    return navigation.get_simple_path(entity.get_global_position(), targetPoint)

static func goTo(entity, path, minDistance=200, delta=1):
    var targetPoint = path[1]
    var distance = (path[-1] - entity.get_global_position()).length()
    targetPoint = entity.to_local(targetPoint)
    var angle = Vector2(0, -1).angle_to(targetPoint)
    entity.set_global_rotation(
        entity.get_global_rotation() + angle)
    var targetInfo = {
        'targetPoint': targetPoint,
        'distance': distance,
        'angle': angle
    }
    if distance < minDistance:
        entity.linear_velocity = Vector2(0, 0)
        return targetInfo
    var orientation = Vector2(0, -1).rotated(entity.rotation).normalized()
    var velocity = orientation * entity.speed
    if velocity.length() > distance:
        velocity = orientation * distance
    entity.linear_velocity = velocity
    return targetInfo