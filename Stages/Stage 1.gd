extends Stage


onready var words = $Words


func _ready():
    stage_manager.goal_position = Vector2(rand_range(100, 1180), rand_range(620, 900))
    

func _enter_tree():
    Game.current_stage = self


func after_start():
    words.display()


func update_glitters(text):
    if text.find("Nothing glitter") >= 0:
        $GlittersBackground.hide()
        $Glitters.emitting = false
    elif not $GlittersBackground.visible:
        $GlittersBackground.show()
        $Glitters.emitting = true


func _on_StageManager_typing_end(text):
    update_glitters(text)
