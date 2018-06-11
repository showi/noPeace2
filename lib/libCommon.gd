extends Node

var version = '0.0.1'
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
    if entity.has_meta('entityKind'):
        return entity.get_meta('entityKind')
    return 'Unknown'
