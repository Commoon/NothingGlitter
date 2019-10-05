extends KinematicBody2D

export var SPEED: float = 300
var velocity = Vector2.ZERO


func _physics_process(delta):
    var x = -1 * Input.get_action_strength("left") + 1 * Input.get_action_strength("right")
    var y = -1 * Input.get_action_strength("up") + 1 * Input.get_action_strength("down")
    velocity = Vector2(x, y).normalized() * SPEED
    move_and_slide(velocity)
