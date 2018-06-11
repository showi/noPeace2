extends Node2D

export (String) var levelName = 'level_01'
onready var common = get_node('/root/libCommon')

func _ready():
    print('[+] ', common.title, ' (', common.version, ')')
    var screensize = common.getScreenSize()
    var level = loadLevel(levelName)
    level.add_child(loadLevelDefault())
    var player = loadPlayer()
    player.set_global_position(Vector2(screensize.x / 2, screensize.y / 2))
    player.rotate(PI)
#    player.set_scale(Vector2(0.25, 0.25))
    level.add_child(player)
    add_child(level)
    print('LevelManager: ', get_path())

func loadLevel(levelName):
    return load(common.getLevelPath(levelName)).instance()

func loadPlayer():
    return load(common.getPlayerPath()).instance()

func loadLevelDefault():
    return load(common.getLevelDefaultPath()).instance()
