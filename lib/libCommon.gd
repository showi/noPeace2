extends Node

var version = '0.0.10'
var title = 'noPeace'

func _ready():
    print('libCommon loaded')

func getLevelPath(levelName):
    return 'res://level/' + levelName + '/Level.tscn'

func getLevel():
    return get_node('/root/Game/LevelManager/Level')

func getLevelManager():
    return get_node('/root/Game/LevelManager')

func getLevelDefaultPath():
    return 'res://lib/LevelDefault.tscn'

func getLevelDefault():
    return get_node('/root/Game/LevelManager/LevelDefault')

func getPlayerPath():
    return 'res://player/Player.tscn'

func getPlayer():
    return get_node('/root/Game/LevelManager/Level/Player')
    
func getScreenSize():
    return get_node('/root').size
    
func getLevelEntity(partialPath):
    return get_node('/root/Game/LevelManager/Level/' + partialPath)
    
func getResource(kind, resourceName):
    return load('res://' + kind + '/' + resourceName + '/' + kind.capitalize() + '.tscn')

func getEntityKind(entity):
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
    BulletEnemy =     5
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

func _init():
    print('CollisionLayer: ', CollisionLayer)
    
func hit(src, entity):
    var kind = getEntityKind(entity)
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
    get_node('/root/Game/LevelManager/Level').add_child(animation)

func setLife(entity, value):
    if entity.life == value:
        return
    entity.life = value
    entity.emit_signal('lifeChanged', value)
    if entity.life <= 0:
        entity.kill()
