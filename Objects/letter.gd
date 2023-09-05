extends Control

@onready var character = $text.text
@export var speed: float = 1.0
var in_target_zone = false

func set_character(inputChar):
	#print("Setting character to %s" % inputChar)
	#inputChar = "%d" % in_targert_zone # for testing	
	character = inputChar
	$text.text = inputChar

func get_character() -> String:
	return character
	
func is_in_target_zone() -> bool:
	return in_target_zone
	
func change_color(color: Color):
	$text.text = "[center][color=%s]%s[/color][/center]" % [color, self.text]

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta
	
func _process(delta: float) -> void:
	if $Area2D.has_overlapping_areas():
		in_target_zone = 1
	else:
		in_target_zone = 0
	
