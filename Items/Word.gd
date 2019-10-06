tool
extends Interactable

signal updated

export var TEXT = "" setget set_text
export var NORMAL_COLOR = Color.white
export var SELECTED_COLOR = Color.red
export var EFFECT_PERIOD = 0.8

onready var text = $Text
onready var collision_shape = $CollisionShape2D

var word = ""
var index = 0
var wait_to_update = -1
var effect_status = -1


func update():
    var vec = text.rect_size / 2
    (collision_shape.shape as RectangleShape2D).extents = vec / 2
    collision_shape.position = vec
    wait_to_update = -1
    text.visible_characters = 0
    emit_signal("updated")


func update_effect():
    if effect_status == -1:
        text.modulate = NORMAL_COLOR
    else:
        text.modulate = NORMAL_COLOR.linear_interpolate(SELECTED_COLOR, (1 - abs(effect_status * 2 - EFFECT_PERIOD) / EFFECT_PERIOD))


func _process(delta):
    if wait_to_update > 0:
        wait_to_update -= 1
    elif wait_to_update == 0:
        update()
    if selected:
        effect_status = 0 if effect_status < 0 else effect_status + delta
        while effect_status >= EFFECT_PERIOD:
            effect_status -= EFFECT_PERIOD
        update_effect()
    elif effect_status >= 0:
        effect_status = -1
        update_effect()


func _ready():
    set_text(TEXT)


func set_text(value):
    TEXT = value
    if text != null:
        text.text = value
        text.hide()
        text.show()
        wait_to_update = 5
    word = strip_word(TEXT)


func can_interact(player):
    var current_words = Game.current_stage.current_words
    return text.visible_characters == text.text.length() and current_words[-1][-1] == word[0] and current_words.find(word) < 0


func is_letter_or_digit(c):
    return 'a' <= c and c <= 'z' or 'A' <= c and c <= 'Z' or '0' <= c and c <= '9'


func strip_word(word: String):
    word = word.strip_edges()
    if word == "":
        return ""
    while not is_letter_or_digit(word[0]):
        word = word.substr(1, word.length() - 1)
    while not is_letter_or_digit(word[-1]):
        word = word.substr(0, word.length() - 1)
    return word


func interact(player):
    Game.current_stage.add_word(word)
    print(1)
    .interact(player)
