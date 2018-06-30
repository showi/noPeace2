extends Node

onready var Speed = load('res://lib/Speed.gd')

var speed

func _ready():
    speed = Speed.Speed.new()

func _process(delta):
    speed.integrate(delta)
    print(speed.toStr())
