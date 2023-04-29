extends Node2D

@onready var character = $text.text

@export var speed: float = 0.5

func get_character() -> String:
		return character
		
func change_color(color: Color):
	$text.text = "[center][color=%s]%s[/color][/center]" % [color, self.text]

func _physics_process(delta: float) -> void:
	global_position.y += speed
