tool
extends Node


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
