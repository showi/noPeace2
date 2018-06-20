extends Node

onready var common = get_node('/root/libCommon')

class PatrolReachTrackState:
    var pathAndPoint

    func handle(sm):
        var entity = sm.entity
        if not pathAndPoint:
            pathAndPoint = sm.common.getClosestPointInPaths(entity, entity.getAirPaths())
            var path = pathAndPoint[0]
        else:
            var path = pathAndPoint[0]
            var targetPoint = entity.to_local(path.to_global(pathAndPoint[1]))
            var distance = targetPoint.length()
            if distance < 5:
                var follow = sm.common.attachEntityToPath(sm.entity, path, pathAndPoint[3])
                sm.setState('patrol', { 'onTrack': follow })
                return
            var angle = Vector2(0, -1).angle_to(targetPoint)
            entity.set_global_rotation(entity.get_global_rotation() + angle)
            var orientation = Vector2(0, -1).rotated(entity.rotation).normalized()
            var velocity = orientation * entity.speed
            if velocity.length() > distance:
                velocity = orientation * distance
            entity.linear_velocity = velocity

class PatrolState:
    var onTrack = null

    func handle(sm):
        if not onTrack:
            return sm.setState('patrol:reachTrack')


    func on_exit(sm):
        if onTrack:
            sm.common.detachEntityFromTrack(sm.entity, onTrack)
            onTrack.queue_free()
            onTrack = null

class FindObjectiveState:
    var objectives = ['patrol']

    func handle(sm):
        for objective in objectives:
            if objective == 'patrol':
                if sm.entity.getAirPaths():
                    return sm.setState('patrol')
        sm.setState('idle')

class ChaseState:
    var target

    func handle(sm):
        if not target:
            return sm.setState('idle')
        var entity = sm.entity
        var navigation = entity.getNavigation()
        if not navigation:
            return sm.setState('idle')
        var path = sm.common.getNavigationPath(entity, target, navigation)
        if not path:
            return sm.setState('idle')
        sm.common.goTo(entity, path[1])

class IdleState:

    func handle(sm):
        if sm.getElapsed() < 250:
            return
        sm.setState('findObjective')

static func getStatesDictionary():
    return {
        'idle': IdleState,
        'findObjective': FindObjectiveState,
        'patrol': PatrolState,
        'patrol:reachTrack': PatrolReachTrackState,
        'chase': ChaseState
    }

static func getStartStateName():
    return 'idle'
