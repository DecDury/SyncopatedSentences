extends Control

# Get child node references
@onready var letter_container = $LetterContainer
@onready var spawn_container = $SpawnContainer
@onready var spawn_timer = $SpawnTimer

# Set game mode
enum {vert, horiz, spelling}
@export var gamemode: int = vert

var Letter = preload("res://Objects/letter.tscn")

var active_letter = null
var current_letter_index: int = -1

func _ready() -> void:
	randomize()
	var index = 0
	#for spawn_point in spawn_container.get_children():
		#var zone_width = $Background/MarginContainer/Rows/LedgerLineContainer/LedgerLines/Zone1.size.x
		#spawn_point.global_position.x = zone_width * index + zone_width/2
		#index += 1
		# TODO here
	spawn_timer.start()


func find_new_active_letter(typed_character: String):
	for letter_node in letter_container.get_children():
		var letter = letter_node.get_child(0).get_parsed_text()
		if letter == typed_character:
			active_letter = letter_node
			print("New Letter! - %s" % letter)
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
	var spawns = spawn_container.get_children() # get spawnpoints
	var index = randi() % spawns.size()
	
	if (gamemode == vert):
		letter_instance.set_character(
			KeyboardMapping.getLetterForColumn(index)
		)
	else: if (gamemode == horiz):
		letter_instance.set_character(
			KeyboardMapping.getLetterForRow(index)
		)
	else: if (gamemode == spelling):
			print("SPAWN LETTER: received spelling gamemode")
	else:
		print("SPAWN LETTER: invalid gamemode")
		
	letter_container.add_child(letter_instance)
	letter_instance.global_position = spawns[index].global_position
	
