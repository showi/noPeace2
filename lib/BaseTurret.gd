extends Area2D

signal lifeSignal(value)

export (float) var speed = 0.25
export (float) var angleThreshold = PI / 10
export (float) var life = 100.0

onready var common = get_node('/root/libCommon')

var target
var orientation = Vector2(0, -1)
var killAnimation

func _ready():
    set_meta('entityKind', 'Enemy')
    killAnimation = common.getResource('explosion', 'explosion_02')
    $CircularDetection.connect('detection', self, 'detection')
    $CircularDetection.connect('loose', self, 'loose')
#    connect('lifeSignal', $Hud/Life, 'setValue')
#    $WeaponSystem.connect("pctChargingSignal", $Hud/Power, 'setValue')
    connect('area_entered', self, 'hit')

func hit(obj):
    common.hit(self, obj)

func detection(kind, player, vab):
    target = player

func loose(kind, player, vab):
    target = null
    $WeaponSystem.setAutoFire(false)

func fire():
    if $WeaponSystem.autoFire:
        return
    $WeaponSystem.setAutoFire(true)
    $WeaponSystem.immediateFire()

func kill():
    common.kill(self, killAnimation)
    call_deferred('_remove')

func _remove():
    get_parent().remove_child(self)

func stopFire():
    $WeaponSystem.setAutoFire(false)

func setLife(value):
    life = value
    emit_signal('lifeSignal', value)

func _process(delta):
    if life <= 0:
        return kill()
    if not target:
        return
    $Link.points[1] = to_local(target.get_global_position())
    var angle = orientation.angle_to(to_local(target.get_global_position()))
    var part = (angle / 0.1) * delta * speed
    $OrientationLine.rotate(part)
    rotate(part)
    if abs(angle) < angleThreshold:
        fire()
    else:
        stopFire()

