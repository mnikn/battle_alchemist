extends Control
signal generate_finished(skill)

export (PoolStringArray) var elements = []

const GENERATE_SUCCESS_DIALOGUE = "你生成了技能{skill}!"
const GENERATE_FAIL_DIALOGUE = "合成失败!"

onready var Input1 = $Output/MarginContainer/VBoxContainer/HBoxContainer/Input1
onready var Input2 = $Output/MarginContainer/VBoxContainer/HBoxContainer/Input2
var DialogueScene = preload("res://components/dialogue/Dialogue.tscn")
var ElementCardScene = preload("res://Card.tscn")

func _ready():
	$Output/MarginContainer/VBoxContainer/HBoxContainer/Generate.disabled = true

func on_snap_change():
	var input1_data = self.Input1.get_node("DragDropTarget").snap_nodes[0] if len(self.Input1.get_node("DragDropTarget").snap_nodes) > 0 else null
	if input1_data != null and input1_data:
		input1_data = input1_data.parent.data
	var input2_data = self.Input2.get_node("DragDropTarget").snap_nodes[0] if len(self.Input2.get_node("DragDropTarget").snap_nodes) > 0 else null
	if input2_data != null:
		input2_data = input2_data.parent.data

	$Output/MarginContainer/VBoxContainer/HBoxContainer/Generate.disabled = input1_data == null or input2_data == null

func _on_Generate_pressed():
	$Output/MarginContainer/VBoxContainer/HBoxContainer/Generate.release_focus()	
	var skill = null
	
	var input1_data = self.Input1.get_node("DragDropTarget").snap_nodes[0] if len(self.Input1.get_node("DragDropTarget").snap_nodes) > 0 else null
	if input1_data != null and input1_data:
		input1_data = input1_data.parent.data
	var input2_data = self.Input2.get_node("DragDropTarget").snap_nodes[0] if len(self.Input2.get_node("DragDropTarget").snap_nodes) > 0 else null
	if input2_data != null:
		input2_data = input2_data.parent.data
	for script in Constants.GENERATE_SKILL_TABLE:
		if input1_data.id == script[0] and input2_data.id == script[1]:
			skill = Constants.SKILLS[script[2]]
		
	$Mask.visible = true
	var node = self.DialogueScene.instance()
	$Popups.add_child(node)
	if skill != null:
		yield(node.show_dialogue([{
			"type": "sentence",
			"content": GENERATE_SUCCESS_DIALOGUE.format({
				"skill": skill.name
				})
			}
		]), "completed")
	else:
		yield(node.show_dialogue([{
			"type": "sentence",
			"content": GENERATE_FAIL_DIALOGUE
		}]), "completed")
	$Mask.visible = false
	
	self.emit_signal("generate_finished", skill, input1_data, input2_data)
	
	self.Input1.get_node("DragDropTarget").remove_all_snap()
	self.Input2.get_node("DragDropTarget").remove_all_snap()


func _on_SysthesisContainer_visibility_changed():
	self.Input1.get_node("DragDropTarget").remove_all_snap()
	self.Input2.get_node("DragDropTarget").remove_all_snap()
	if self.visible:
		NodeUtils.clear_children($BottomPanel/MarginContainer/GridContainer)
		for item in self.elements:
			var node = self.ElementCardScene.instance()
			node.data = item
			$BottomPanel/MarginContainer/GridContainer.add_child(node)
	else:
		$Output/MarginContainer/VBoxContainer/HBoxContainer/Generate.disabled = true
