extends TextureButton


 
export (String) var text = "" setget set_text

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func set_text(value):
	if self == null:
		return
	$Label.text = value
