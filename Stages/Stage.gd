extends Node2D

class_name Stage

export var STAGE_NUMBER: int = 0

onready var stage_manager: StageManager = $StageManager

const COLORS = ["red", "blue", "green", "cyan", "yellow", "purple"]
var color_index = -1
var current_words = ["Nothing"]


func _ready():
    pause_mode = Node.PAUSE_MODE_STOP
    

func _enter_tree():
    Game.current_stage = self


func add_word(word):
    var title_text = stage_manager.title_text as RichTextLabel
    if title_text.text[-1] != word[0]:
        return
    var bbcode = title_text.bbcode_text
    color_index = (color_index + 1) % COLORS.size()
    var new_bbcode = "%s[color=%s]%c %c[/color]%s" % [
        bbcode.substr(0, bbcode.length() - 1),
        COLORS[color_index],
        bbcode[-1], word[0],
        word.substr(1, word.length() - 1)
    ]
    current_words.append(word)
    title_text.bbcode_text = new_bbcode


func remove_word():
    if current_words.size() <= 1:
        return
    var title_text = stage_manager.title_text as RichTextLabel
    if not title_text.text.ends_with(current_words[-1]):
        return
    var word = current_words.pop_back()
    var to_delete_length = word.length() + COLORS[color_index].length() + "[color=] [/color]".length() + 1
    var bbcode = title_text.bbcode_text
    var new_bbcode = "%s%c" % [bbcode.substr(0, bbcode.length() - to_delete_length), word[0]]
    title_text.bbcode_text = new_bbcode
    var n = title_text.text.length()
    title_text.visible_characters = n
    stage_manager.typing = n
    stage_manager.emit_signal("typing_end", title_text.text)
    color_index = (color_index - 1) % COLORS.size()
