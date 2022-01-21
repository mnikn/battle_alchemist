extends Control
signal generate_finished(skill)

export (PoolStringArray) var fundmentals = []

onready var Input1 = $Output/MarginContainer/HBoxContainer/Input1
onready var Input2 = $Output/MarginContainer/HBoxContainer/Input2
	
func _process(delta):
	var input1_data = self.Input1.get_node("DragDropTarget").snap_nodes[0] if len(self.Input1.get_node("DragDropTarget").snap_nodes) > 0 else null
	if input1_data != null:
		input1_data = input1_data.parent.data
	var input2_data = self.Input2.get_node("DragDropTarget").snap_nodes[0] if len(self.Input2.get_node("DragDropTarget").snap_nodes) > 0 else null
	if input2_data != null:
		input2_data = input2_data.parent.data

	$Output/MarginContainer/HBoxContainer/Generate.disabled = input1_data == null or input2_data == null

func _on_Generate_pressed():
	var skill = Constants.SKILLS.water_ball
	self.emit_signal("generate_finished", skill)
