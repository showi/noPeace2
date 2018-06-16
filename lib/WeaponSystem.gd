extends Node

export (String) var ammoPath = "res://ammo/energy_ball/Ammo.tscn"
export (float) var cooldown = 0.5
export (bool) var autoFire = false
export (int, 4, 5) var ammoCollisionLayer = 5

signal pctChargingSignal(percentage)

onready var common = get_node('/root/libCommon')

var ammoClass
var ammo
var disabled = true
var elapsed = 0
var elapsedCoolDown = 0

enum STATES {
    idle,
    charging,
    cooldown
}

var state = STATES.cooldown
var pctCharging = 0.0
var isAutofiring = false

func _init():
    loadAmmo(ammoPath)

func _ready():
    setAutoFire(autoFire)
    state = STATES.idle
    setPctCharging(0)

func loadAmmo(ammoPath):
    ammoClass = load(ammoPath)

func getWorld():
    var world = common.getLevelEntity('LevelDefault/bullets')
    if not world:
        world = get_parent()
    return world

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
    if state == STATES.charging:
        return releaseFire()
    elif state != idle:
        return
    elapsed = 0
    pctCharging = 0
    state = STATES.charging
    ammo = ammoClass.instance()
    ammo.setWeaponSystem(self)
    return true

func releaseFire():
    if state != STATES.charging:
        return false
    state = STATES.cooldown
    getWorld().add_child(ammo)
    ammo.fire(pctCharging)
    setPctCharging(0)
    return true

func getShooter():
    return get_parent()

func setPctCharging(value):
        pctCharging = value
        emit_signal('pctChargingSignal', pctCharging * 100)

func _process(delta):
    if state == STATES.cooldown:
        if elapsedCoolDown < cooldown:
            elapsedCoolDown += delta
        else:
            elapsedCoolDown = 0
            state = STATES.idle
    if state == STATES.charging:
        elapsed += delta
        setPctCharging(clamp((elapsed / ammo.fullPowerTime), 0, 1.0))
    elif state == STATES.idle and isAutofiring:
        immediateFire()