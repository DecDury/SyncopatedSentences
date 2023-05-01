extends Node2D

@onready var character = $text.text
@export var speed: float = 1.0

func set_character(inputChar: String):
	print("Setting character to %s" % inputChar)
	character = inputChar
	$text.text = inputChar

func get_character() -> String:
	return character
	
func change_color(color: Color):
	$text.text = "[center][color=%s]%s[/color][/center]" % [color, self.text]

func _physics_process(delta: float) -> void:
	global_position.y += speed
	
