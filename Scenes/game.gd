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
var letter_in_zone = 0

func _ready() -> void:
	var ledger_line_container = $Background/MarginContainer/Rows/LedgerLineContainer
	var zonewidth = 0
	
	randomize()
	# TODO
	# Fix spawn point position
	spawn_timer.start()


func find_new_active_letter(typed_character: String):
	for letter_node in letter_container.get_children():
		var letter = letter_node.get_child(0).get_parsed_text()
		
		if letter == typed_character || letter == check_if_special_character(typed_character):
			active_letter = letter_node
			print("Letter Match! - %s" % letter)
			
			if letter_in_zone:
				active_letter.queue_free()
				active_letter = null
		else:
			print("Incorrectly typed %s instead of %s" % [typed_character, letter] )


func check_if_special_character(typed_character: String) -> String:
	match typed_character:
		"Semicolon":
			typed_character = ";"
		"Comma":
			typed_character = ","
		"Period":
			typed_character = "."
		"Slash":
			typed_character = "/"
	
	return typed_character


func _unhandled_input(event: InputEvent) -> void:
	var typed_event: InputEventKey
	var key_typed: String
	var colString: String
	var style: StyleBoxFlat
	
	if event is InputEventKey and not event.is_pressed():
		typed_event = event as InputEventKey
		#var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		key_typed = typed_event.as_text()
		print("Key: " + key_typed)
		
		# Only for verticle
		for colStringIndex in KeyboardMapping.vert_mapping.size():
			colString = KeyboardMapping.vert_mapping[colStringIndex]
			if colString.contains(key_typed):
				style = StyleBoxFlat.new()
				style.bg_color = Color.GREEN
				var target_zone_name = "Zone%d" % (colStringIndex + 1)
				print("Attempting to change %s color" % target_zone_name)
				add_theme_stylebox_override(target_zone_name, style)
			
			
		
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
	


func target_zone_entered(area: Area2D) -> void:
	letter_in_zone = 1
	print("Letter in zone")


func target_zone_exited(area: Area2D) -> void:
	letter_in_zone = 0
	print("Letter left zone")
