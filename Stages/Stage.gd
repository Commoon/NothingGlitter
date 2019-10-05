extends Node2D

class_name Stage

export var STAGE_NUMBER: int = 0

onready var stage_manager: StageManager = $StageManager


func _ready():
    print("ready")
    pause_mode = Node.PAUSE_MODE_STOP
    

func _enter_tree():
    Game.current_stage = self

