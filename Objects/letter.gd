extends Node2D

@export var speed: float = 1.0

enum {miss, early, perfect, late}
var punctuality: int = miss
var in_target_zone = false

#-------------------------
# text component
#-------------------------
func set_character(inputChar):
	#print("Setting character to %s" % inputChar)
	#inputChar = "%d" % in_targert_zone # for testing	
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
func is_in_target_zone() -> bool:
	return in_target_zone

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta
	
func _process(delta: float) -> void:
	if $Area2D.has_overlapping_areas():
		in_target_zone = 1
	else:
		in_target_zone = 0
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	
	pass # Replace with function body.
