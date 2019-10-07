extends Node2D

var credit_ended = false


func _input(event):
    if credit_ended and event.is_action_released("search"):
        Game.next_stage()
