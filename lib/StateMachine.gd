extends Node

class StateMachine:

    signal newState(stateName)

    var currentState
    var currentStateName
    var statesDictionary
    var lastMsTick = 0
    var entity
    var common
    var lastDelta = 0

    func _init(_common, _entity, _statesDictionary, stateName):
        common = _common
        entity = _entity
        statesDictionary = _statesDictionary
        setState(stateName)

    func setState(stateName, attributes=null):
        if currentState and currentState.has_method('on_exit'):
            currentState.call('on_exit', self)
        currentStateName = stateName
        currentState = statesDictionary[currentStateName].new()
        common.setObjectAttributes(currentState, attributes)
        lastMsTick = OS.get_ticks_msec()
        emit_signal('newState', stateName)

    func getElapsed():
        return OS.get_ticks_msec() - lastMsTick;

    func request(delta):
        lastDelta = delta
        return currentState.handle(self)
