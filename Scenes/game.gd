extends Control

@onready var letter_container = $LetterContainer
@onready var spawn_container = $SpawnContainer
@onready var spawn_timer = $SpawnTimer

var Letter = preload("res://Objects/letter.tscn")

var active_letter = null
var current_letter_index: int = -1

func _ready() -> void:
	randomize()
	var index = 0
	spawn_timer.start()


func find_new_active_letter(typed_character: String):
	for letter_node in letter_container.get_children():
		var letter = letter_node.text.get_parsed_text()
		if letter == typed_character:
			active_letter = letter_node
			print("New Letter!")
			active_letter.queue_free()
			active_letter = null
		else:
			print("Incorrectly typed %s instead of %s" % [typed_character, letter] )


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed():
		var typed_event = event as InputEventKey
		#var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		var key_typed = typed_event.as_text()
		print("Key: " + key_typed)
		
		if active_letter == null:
			find_new_active_letter(key_typed)


func _on_spawn_timer_timeout() -> void:
	spawn_letter()
	
	
func spawn_letter():
	var letter_instance = Letter.instantiate()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	letter_container.add_child(letter_instance)
	letter_instance.global_position = spawns[index].global_position
	
