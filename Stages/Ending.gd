extends Node2D

export var WAITING_TIME = 1.0

var credit_ended = false
var waiting = 0.0


func _process(delta):
    if credit_ended:
        return
    waiting += delta
    if waiting > WAITING_TIME:
        credit_ended = true


func _unhandled_input(event):
    if credit_ended and event.is_action_released("search"):
        Game.start(0)
