extends Stage

onready var arrows = $Node2D.get_children()
onready var words = $Words.get_children()
onready var player = $Player
onready var start_point = player.position

var first_time = true


func start_arrows():
    for each in arrows:
        each.start()


func stop_arrows():
    for each in arrows:
        each.stop()


func _on_StageManager_started():
    for each in arrows:
        each.connect("hit", self, "_on_hit")
    start_arrows()
    for each in words:
        each.display()


func _on_hit(arrow):
    Utils.play_hit_sound()
    player.position = start_point


func _on_StageManager_typing_end(text):
    if first_time:
        first_time = false
        return
    if Utils.check_phrase("Nothing goes straight through horizontal line", text):
        finish_sentence()
        stop_arrows()
    else:
        start_arrows()
