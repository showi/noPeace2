extends Node

export (float) var speed = 10
export (float) var minVelocity = 0
export (float) var maxVelocity = 400

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
    return vector.rotated(parent.get_global_rotation()).normalized() * currentSpeed

func up():
    parent.apply_impulse(parent.position, get_impulse(VECTOR_UP))
    _pressDirection(Direction.UP)

func down():
    parent.apply_impulse(parent.position, get_impulse(VECTOR_DOWN))
    _pressDirection(Direction.DOWN)

func right():
    parent.apply_impulse(parent.position, get_impulse(VECTOR_RIGHT))
    _pressDirection(Direction.RIGHT)

func left():
    parent.apply_impulse(parent.position, get_impulse(VECTOR_LEFT))
    _pressDirection(Direction.LEFT)


