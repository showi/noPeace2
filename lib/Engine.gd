extends Node2D

export (float) var speed = 10
export (float) var rotationSpeed = 1000

export (float) var minVelocity = 0
export (float) var maxVelocity = 200

enum Direction {
    UP,
    RIGHT,
    DOWN,
    LEFT
}

const VECTOR_UP = Vector2(0, -1)
const VECTOR_DOWN = Vector2(0, 1)
const VECTOR_RIGHT = Vector2(1, 0)
const VECTOR_LEFT = Vector2(-1, 0)

onready var parent = get_parent()

var disabled = false
var timer = null
var lastTimePress = null
var direction = null
var currentSpeed
var isNewDirection = true
var lastImpulse = Vector2(0, 0)
var _rotate = 0

func _ready():
    currentSpeed = 0.1 * speed

func _pressDirection(_direction):
    if _direction != direction:
        isNewDirection = true
    else:
        isNewDirection = false
    direction = _direction
    lastTimePress = OS.get_ticks_msec()

func get_impulse(vector):
    lastImpulse = vector.rotated(parent.get_rotation()).normalized() * currentSpeed
    return lastImpulse

func up():
    parent.apply_impulse(position, get_impulse(VECTOR_UP))
    _pressDirection(Direction.UP)

func down():
    parent.apply_impulse(position, get_impulse(VECTOR_DOWN))
    _pressDirection(Direction.DOWN)

func _rotate(direction, radiant):
    _rotate= radiant
    parent.apply_impulse(Vector2(0, -20), Vector2(radiant, 0))

func right():
    parent.apply_impulse(position, get_impulse(VECTOR_RIGHT))
    _pressDirection(Direction.RIGHT)

func left():
    parent.apply_impulse(position, get_impulse(VECTOR_LEFT))
    _pressDirection(Direction.LEFT)

func aero_right():
    _rotate(1, rotationSpeed)
    _pressDirection(Direction.RIGHT)

func aero_left():
    _rotate(-1, -rotationSpeed)
    _pressDirection(Direction.LEFT)

func _process(delta):
    $Speed.points[1] = lastImpulse * 10

func _integrate_forces(delta):
    print('integrate')
    if _rotate:
        _rotate = 0
