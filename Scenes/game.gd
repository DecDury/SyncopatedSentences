extends Control

# Get child node references
@onready var letter_container = $LetterContainer
@onready var spawn_container = $SpawnContainer
@onready var spawn_timer = $SpawnTimer
@onready var ledger_line_container = $Background/MarginContainer/Rows/LedgerLineContainer
@onready var current_score_ui = $Background/CanvasLayer/HBoxContainer/Panel/CurrentScoreUI
# Set game mode
enum {vert, horiz, spelling}
@export var gamemode: int = vert

# preload letter scene
var Letter = preload("res://Objects/letter.tscn")

var active_letter = null
var letters_in_zone = []
var current_score = 0

func _ready() -> void:
	var zonewidth = 0
	
	randomize()
	# TODO
	# Fix spawn point position
	spawn_timer.start()
	
func _process(delta: float) -> void:
	current_score_ui.text = "[center]%03d[/center]" % current_score


func find_new_active_letter(typed_character: String):
	var letter: String
	for letter_node in letters_in_zone:
		if letter_node != null:
			letter = letter_node.get_child(0).get_parsed_text()
		
		if letter == typed_character || letter == check_if_special_character(typed_character):
			active_letter = letter_node
			current_score += 100
			print("CORRECT: %s - Score: %d" % [letter, current_score])
			
			if (active_letter != null):
				active_letter.queue_free()
			active_letter = null
		else:
			current_score -= 10
			print("INCORRECT: %s - Score: %d" % [letter, current_score])


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


func _input(event: InputEvent) -> void:
	var typed_event: InputEventKey
	var key_typed: String
	var colString: String
	var style: StyleBoxFlat
	
	if event is InputEventKey and not event.is_pressed():
		typed_event = event as InputEventKey
		#var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		key_typed = typed_event.as_text()
		#print("INPUT: " + key_typed)
		
		# Only for verticle
		for colStringIndex in KeyboardMapping.vert_mapping.size():
			colString = KeyboardMapping.vert_mapping[colStringIndex]
			#print("colString and key_typed: %s ---  %s" % colString, key_typed )
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
	pass
	
	
func spawn_letter():
	var letter_instance = Letter.instantiate()
	var spawns = spawn_container.get_children() # get spawnpoints
	var index = randi() % spawns.size()
	
	match gamemode:
		vert:
			letter_instance.set_character(
				KeyboardMapping.getLetterForColumn(index)
			)
		horiz:
			letter_instance.set_character(
				KeyboardMapping.getLetterForRow(index)
			)
		spelling:
			print("SPAWN LETTER: received spelling gamemode")
		_:
			print("SPAWN LETTER: invalid gamemode")
		
	letter_container.add_child(letter_instance)
	letter_instance.global_position = spawns[index].global_position

func target_zone_entered(area: Area2D) -> void:
	letters_in_zone.push_back(area.get_parent())


func target_zone_exited(area: Area2D) -> void:
	if (letters_in_zone[0] != null && letters_in_zone[0] == area.get_parent()):
		var temp_pointer = letters_in_zone.pop_front()
		# TODO
		# Need to fix score being decremented after
		# letter has been successfully matched
		#current_score -= 10
		print("MISSED LETTER: %s - Score: %d" % [temp_pointer.get_child(0).text, current_score])
		temp_pointer.queue_free()
		temp_pointer = null
		
		



