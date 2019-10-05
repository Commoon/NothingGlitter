tool
extends Interactable

export var TEXT = "" setget set_text

onready var text = $Text

func update():
    ($CollisionShape2D.shape as RectangleShape2D).extents = text.rect_size / 2


func _ready():
    update()


func set_text(value):
    TEXT = value
    if text != null:
        text.text = value
        update()

