extends PanelContainer

var data

func _ready():
	$MarginContainer/VBoxContainer/Label.text = self.data.name
