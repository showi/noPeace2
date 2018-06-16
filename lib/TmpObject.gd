extends Node2D

export (float) var timeout = 3.0

var timer

func _ready():
    setTimer()

func setTimer():
    timer = Timer.new()
    timer.one_shot = true
    timer.wait_time = timeout
    timer.connect('timeout', self, 'kill')

func start():
    timer.start()

func kill():
    call_deferred('_remove')

func _remove():
    get_parent().remove_child(self)
