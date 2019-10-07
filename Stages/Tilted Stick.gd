extends Stage

export var ROTATE_SPEED = 1.5

onready var stick = $Stick
onready var stick_bottom = stick.position + Vector2.DOWN * 256.0

var started = false
var reversed = false
var first_time = true


func _on_StageManager_started():
    started = true


func _physics_process(delta):
    if started:
        var direction = Vector2.UP.rotated(stick.rotation)
        if not reversed and (stick.position + 256.0 * direction).x >= 1280:
            started = false
            if first_time:
                $Words1.display()
                first_time = false
        elif reversed and stick.rotation <= 0:
            started = false
            stick.rotation = 0.0
        else:
            stick.rotate(ROTATE_SPEED * delta * (-1 if reversed else 1))
            stick.position = stick_bottom + 256.0 * direction


func update_stick(text):
    if Utils.check_phrase("Nothing got tilted", text):
        finish_sentence()
        reversed = true
    else:
        reversed = false
    started = true
        

func _on_StageManager_typing_end(text):
    if not first_time:
        update_stick(text)


func _on_Potato_interacted(potato):
    potato.queue_free()
    $Words2.display()
