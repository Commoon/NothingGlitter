extends Node2D


var selected_stage = -1
onready var select_label = $SelectStage

func set_stage(stage_number):
    selected_stage = Game.max_cleared_stage if stage_number > Game.max_cleared_stage \
        else 0 if stage_number < 0 else stage_number
    select_label.text = "Go to Stage %d" % selected_stage


func _unhandled_input(event):
    if selected_stage >= 0:
        if event.is_action_released("search"):
            Game.start(selected_stage)
        elif event.is_action_released("cancel"):
            selected_stage = -1
            select_label.hide()
            $Label2.show()
        elif event.is_action_released("up"):
            set_stage(selected_stage + 1)
        elif event.is_action_released("down"):
            set_stage(selected_stage - 1)
    else:
        if event.is_action_released("search"):
            Game.next_stage()
        elif event.is_action_released("home"):
            set_stage(Game.max_cleared_stage)
            select_label.show()
            $Label2.hide()
