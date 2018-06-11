extends Node

export (String) var ammoPath = "res://ammo/energy_ball/Ammo.tscn"
export (float) var cooldown = 1.0
export (bool) var autoFire = false

signal pctChargingSignal(percentage)

onready var common = get_node('/root/libCommon')

var ammoClass
var ammo
var disabled = true
var timer
var elapsed = 0

enum STATES {
    idle,
    charging,
    cooldown
}

var state = STATES.cooldown
var pctCharging = 0.0
var world
var shooter
var isAutofiring = false

func _init():
    loadAmmo(ammoPath)
    timer = Timer.new()
    timer.one_shot = true
    timer.set_wait_time(cooldown)
    timer.connect('timeout', self, 'setState', [STATES.idle])

func _ready():
    add_child(timer)
    world = common.getLevelEntity('LevelDefault/bullets')
    shooter = get_parent()
    setAutoFire(autoFire)
    state = STATES.idle

func loadAmmo(ammoPath):
    ammoClass = load(ammoPath)

func setState(p_state):
    state = p_state

func setAutoFire(value):
    autoFire = value
    if autoFire:
        isAutofiring = true
    else:
        isAutofiring = false

func immediateFire():
    pressFire()
    releaseFire()

func pressFire():
    elapsed = 0
    pctCharging = 0
    state = STATES.charging
    ammo = ammoClass.instance()

func releaseFire():
    if state != STATES.charging:
        return
    state = STATES.cooldown
    ammo.fire(world, shooter, pctCharging)
    timer.start()

func _process(delta):
    if state == STATES.charging:
        elapsed += delta
        pctCharging = clamp((elapsed / ammo.fullPowerTime) * 100, 0, 100)
        emit_signal('pctChargingSignal', pctCharging)
    elif state == STATES.idle and isAutofiring:
        immediateFire()