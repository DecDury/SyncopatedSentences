extends Node2D

@export var speed: float = 1.0

enum {miss, early, perfect, late}
var punctuality: int = miss

#-------------------------
# text component
#-------------------------
func set_character(inputChar):
	$text.text = inputChar

func get_character() -> String:
	return $text.text
	
func change_color(color: Color):
	$text.text = "[center][color=%s]%s[/color][/center]" % [color, self.text]
	
func set_punctuality(time: int):
	punctuality = time


#-------------------------
# Physics and Position
#-------------------------
func _physics_process(delta: float) -> void:
	global_position.y += speed * delta

func _on_area_2d_area_entered(_area: Area2D) -> void:
	#punctuality += 1
	print("%s - %s: [Punctuality = %d]" % [name, $text.text, punctuality])
