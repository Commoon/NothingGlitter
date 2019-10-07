tool
extends Node

const WORD_SOUND_EFFECTS = [
    preload("res://Assets/sfx/do.wav"),
    preload("res://Assets/sfx/re.wav"),
    preload("res://Assets/sfx/mi.wav"),
    preload("res://Assets/sfx/fa.wav"),
    preload("res://Assets/sfx/so.wav")
]
const COMPLETE_SOUND_EFFECT = preload("res://Assets/sfx/complete.wav")
const HIT_SOUND_EFFECT = preload("res://Assets/sfx/hit.wav")

var se_player: AudioStreamPlayer = null
var word_player: AudioStreamPlayer = null

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


func check_phrase(phrase: String, text = null):
    if text == null:
        text = Game.current_stage.stage_manager.title_text.text
    text = text.to_lower()
    phrase = phrase.to_lower()
    return text.find(phrase) >= 0


func play_sound(player, stream):
    if player == null:
        return
    player.stream = stream
    player.play()
    

func play_word_sound(i):
    play_sound(word_player, WORD_SOUND_EFFECTS[i % WORD_SOUND_EFFECTS.size()])


func play_complete_sound():
    play_sound(se_player, COMPLETE_SOUND_EFFECT)


func play_hit_sound():
    play_sound(se_player, HIT_SOUND_EFFECT)
