extends Interactable

export var ROTATION_SPEED = 2.0


func _ready():
    item_name = "goal"


func interact(player):
    Utils.play_complete_sound()
    Game.win()


func _process(delta):
    rotate(ROTATION_SPEED * delta)
