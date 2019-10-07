tool
extends Node2D

signal hit

export var SPEED = 1600.0
export var PAUSE = 0.8
export var START_VALUE = 0.0
export var END_VALUE = 1280.0 + 128.0
export var TO_RIGHT = true setget set_direction

onready var arrow = $Arrow
onready var started = false
var stopped = false
var pause = -1


func set_direction(value):
    TO_RIGHT = value
    rotation_degrees = 90.0 if value else -90.0


func _ready():
    set_direction(TO_RIGHT)
    

func _physics_process(delta):
    if not started:
        return
    if pause > 0:
        pause -= delta
        if pause <= 0:
            arrow.show()
        return
    var p = arrow.position
    p += Vector2.UP * delta * SPEED
    if abs(p.y) >= END_VALUE:
        pause = PAUSE
        arrow.hide()
        arrow.position.y = START_VALUE
        if stopped:
            started = false
            stopped = false
    else:
        arrow.position = p


func start():
    started = true
    arrow.show()


func stop():
    stopped = true


func _on_Arrow_select_changed(selected):
    if started and selected:
        emit_signal("hit", self)
