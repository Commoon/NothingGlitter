tool
extends Node2D

signal typing_end

class_name StageManager

export var typing_speed = 4.5
export var starting_pause = 0.5
export var goal_position = Vector2(1040, 720) setget set_goal_position

onready var title_text = $TitleText
onready var player = $Player
onready var goal = $Goal
var started = false
var showing_player = -1
var typing = -1

onready var stage = get_parent()


func _ready():
    title_text.visible_characters = 0
    player.hide()
    goal.hide()
    title_text.bbcode_text = "Stage %d: Nothing" % stage.STAGE_NUMBER
    typing = 0
    showing_player = 0


func _process(delta):
    if typing < 0 or title_text == null:
        return
    var n = title_text.text.length()
    if typing < n:
        typing = min(typing + delta * typing_speed, n)
        title_text.visible_characters = floor(typing)
        if typing == n:
            emit_signal("typing_end", title_text.text)
    elif not started:
        showing_player += delta
        if showing_player >= 2 * starting_pause:
            goal.show()
            started = true
            stage.call_deferred("after_start")
        elif showing_player >= starting_pause:
            player.show()


func set_goal_position(value):
    goal_position = value
    if goal != null:
        goal.position = value
