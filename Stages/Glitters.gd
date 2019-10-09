extends Stage


onready var words = $Words
onready var glitters_background = $GlittersBackground
onready var glitters = $Glitters


func _ready():
    # var box = (glitters.process_material as ParticlesMaterial).emission_box_extents
    # var x = (randf() * 2 - 1) * box.x * 0.9
    # var y = (randf() * 2 - 1) * box.y * 0.9
    # stage_manager.goal_position = Vector2(x, y) + glitters.position
    pass


func update_glitters(text):
    if Utils.check_phrase("Nothing glitter", text):
        finish_sentence()
        glitters_background.hide()
        glitters.emitting = false
    elif not $GlittersBackground.visible:
        glitters_background.show()
        glitters.emitting = true


func _on_StageManager_typing_end(text):
    update_glitters(text)


func _on_StageManager_started():
    words.display()
