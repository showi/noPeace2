extends Node2D

export (String) var levelName = 'level_02'
export (bool) var recording = false

onready var common = get_node('/root/libCommon')
var freq = 1 / 30
var elapsed = 0
var frameIdx = 0

func _ready():
    start()

func start():
    print('[+] ', common.title, ' (', common.version, ')')
    var screensize = common.getScreenSize()
    var level = loadLevel(levelName)
    level.add_child(loadLevelDefault())
    var player = loadPlayer()
    player.set_global_position(Vector2(screensize.x / 2, screensize.y / 2))
    var playerAttach
    if not playerAttach or not playerAttach.visible:
        playerAttach = level
    playerAttach.add_child(player)
    add_child(level)
    print('LevelManager: ', get_path())

func loadLevel(levelName):
    print('LoadLevel: ', levelName)
    return load(common.getLevelPath(levelName)).instance()

func loadPlayer():
    return load(common.getPlayerPath()).instance()

func loadLevelDefault():
    return load(common.getLevelDefaultPath()).instance()

func gameOver():
    print('gameOver')
    get_node('Level').set_pause_mode(PAUSE_MODE_STOP)

func _gameOver():
    get_node('Level').queue_free()
    var t = Timer.new()

func screenRecorder(idx = 0):
    var path = '../../Movies/noPeace/'
    var prefix = 'screenshot_'
    var extension = '.png'
    var img = get_viewport().get_texture().get_data()
    img.flip_y()
    img.save_png('%s%s%04d%s' % [path, prefix, idx, extension])

func _process(delta):
    if recording:
        elapsed += delta
        if elapsed > freq:
            elapsed -= freq
            screenRecorder(frameIdx)
            frameIdx += 1
