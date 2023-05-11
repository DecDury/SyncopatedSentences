extends Node2D

@onready var character = $text.text
@export var speed: float = 1.0
var in_targert_zone = false

func set_character(inputChar: String):
	#print("Setting character to %s" % inputChar)
	#inputChar = "%d" % in_targert_zone # for testing
	character = inputChar
	$text.text = inputChar

func get_character() -> String:
	return character
	
func is_in_target_zone() -> bool:
	return $Area2D.has_overlapping_areas()
	
func change_color(color: Color):
	$text.text = "[center][color=%s]%s[/color][/center]" % [color, self.text]

func _physics_process(delta: float) -> void:
	global_position.y += speed
	
func _process(delta: float) -> void:
	if $Area2D.has_overlapping_areas():
		in_targert_zone = 1
	
