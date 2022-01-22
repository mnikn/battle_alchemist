extends Control
signal generate_finished(skill)

export (PoolStringArray) var fundmentals = []

const GENERATE_SUCCESS_DIALOGUE = "你生成了技能{skill}!"
const GENERATE_FAIL_DIALOGUE = "合成失败!"

onready var Input1 = $Output/MarginContainer/VBoxContainer/HBoxContainer/Input1
onready var Input2 = $Output/MarginContainer/VBoxContainer/HBoxContainer/Input2
var DialogueScene = preload("res://components/dialogue/Dialogue.tscn")

func _ready():
	$Mask.visible = false

func _process(delta):
	var input1_data = self.Input1.get_node("DragDropTarget").snap_nodes[0] if len(self.Input1.get_node("DragDropTarget").snap_nodes) > 0 else null
	if input1_data != null:
		input1_data = input1_data.parent.data
	var input2_data = self.Input2.get_node("DragDropTarget").snap_nodes[0] if len(self.Input2.get_node("DragDropTarget").snap_nodes) > 0 else null
	if input2_data != null:
		input2_data = input2_data.parent.data

	$Output/MarginContainer/VBoxContainer/HBoxContainer/Generate.disabled = input1_data == null or input2_data == null

func _on_Generate_pressed():
	$Output/MarginContainer/VBoxContainer/HBoxContainer/Generate.release_focus()	
	var skill = Constants.SKILLS.water_ball
	
	$Mask.visible = true
	var node = self.DialogueScene.instance()
	$Popups.add_child(node)
	yield(node.show_dialogue([{
		"type": "sentence",
		"content": GENERATE_SUCCESS_DIALOGUE.format({
			"skill": skill.name
			})
		}
	]), "completed")
	$Mask.visible = false
	
	self.emit_signal("generate_finished", skill)
	
	self.Input1.get_node("DragDropTarget").remove_all_snap()
	self.Input2.get_node("DragDropTarget").remove_all_snap()
