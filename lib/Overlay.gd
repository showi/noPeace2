extends GridContainer

onready var common = get_node('/root/libCommon')

func _ready(): 
    $ColorRect/name.setKeyValue('name', common.title)
    $ColorRect/version.setKeyValue('version', common.version)