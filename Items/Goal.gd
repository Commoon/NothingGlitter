extends Interactable


func _ready():
    item_name = "goal"


func interact(player):
    Game.win()
