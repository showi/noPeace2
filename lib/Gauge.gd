extends Control

export (String) var gaugeName = "One Gauge"
export (float) var minimum = 0.0
export (float) var maximum = 100.0
export (float) var value = 33.33

var gauge = null
var gaugeDefaultSize = null

func getPercentage():
    return clamp(value, minimum, maximum) / maximum * 100

func _ready():
    gauge = $Gauge
    gaugeDefaultSize = gauge.get_size()

func _process(delta):
    var size = gauge.get_size()
    size.x = gaugeDefaultSize.x * getPercentage() / 100
    gauge.set_size(size)
