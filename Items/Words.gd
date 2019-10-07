tool
extends Node2D
export var typing_speed = 12
export var LINE_HEIGHT = 48
export (String, MULTILINE) var TEXT = "" setget set_text

var word_prefab = preload("./Word.tscn")

var word_nodes = []
var words: PoolStringArray = []

var typing = -1
var length = -1
var waiting = -1


func _process(delta):
    if typing < 0 or typing >= length:
        return
    typing = min(typing + delta * typing_speed, length)
    var progress = floor(typing)
    var i = 0
    for word in words:
        var l = 1 if word == "\n" else (word.length() + 1)
        if progress <= l:
            if word != "\n":
                word_nodes[i].text.visible_characters = progress
            break
        progress -= l
        if word != "\n":
            i += 1


func display():
    if typing == -1:
        typing = 0


func word_updated():
    waiting -= 1
    if waiting != 0:
        return
    var current_position = Vector2.ZERO
    var i = 0
    for word in words:
        if word == "\n":
            current_position.x = 0.0
            current_position.y += LINE_HEIGHT
            continue
        var word_node = word_nodes[i]
        var text = word_node.get_node("Text")
        word_node.position = current_position
        current_position.x += text.rect_size.x
        i += 1


func update_words():
    for child in get_children():
        child.queue_free()
    length = 0
    word_nodes = []
    for word in words:
        if word == "\n":
            length += 1
            continue
        var word_node = word_prefab.instance()
        word_node.TEXT = word + " "
        length += word.length() + 1
        word_node.index = word_nodes.size()
        word_node.connect("updated", self, "word_updated")
        word_nodes.append(word_node)
    waiting = word_nodes.size()
    for word_node in word_nodes:
        add_child(word_node)


func set_text(value):
    TEXT = value
    words = []
    var first_line = true
    for line in value.split("\n"):
        if not first_line:
            words.append("\n")
        for word in line.split(" "):
            if not word.empty():
                words.append(word)
        first_line = false
    update_words()

func _ready():
    update_words()
