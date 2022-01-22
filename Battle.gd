extends Node2D

onready var SummaryPanel = $UI/BottomPanel/MarginContainer/HBoxContainer/SummaryPanel
onready var ActionPanel = $UI/BottomPanel/MarginContainer/HBoxContainer/ActionPanel
onready var SkillPanel = $UI/BottomPanel/MarginContainer/HBoxContainer/SkillPanel
onready var SkillList = $UI/BottomPanel/MarginContainer/HBoxContainer/SkillPanel/MarginContainer/GridContainer
onready var Dialogue = $UI/BottomPanel/MarginContainer/HBoxContainer/Dialogue
onready var DialogueContent = $UI/BottomPanel/MarginContainer/HBoxContainer/Dialogue/MarginContainer/Content

onready var SkillItemScene = preload("res://SkillItem.tscn")

export (String) var enmey = "" 

var creatures = {
	"slime": {},
	"skeleton": {},
	"troll": {},
	"balrog": {},
	"king": {}
}

var physic_elements = ["fire", "mud", "ice", "water"]
var mental_elements = ["courage", "crash", "cool", "firm"]

const generate_skill_tale = {
	"fire_ball": ["fire", "concentrated"],
	"rock_fall": ["mud", "crash"],
	"big_fire_ball": ["fire_ball", "firm"],
	"water_ball": ["water", "concentrated"],
	"big_rain": ["water_ball", "firm"],
	"petrification": ["mud", "cool"],
	"frezz": ["ice", "cool"],
	"last_light": ["human", "courage"]
}

var state = {
	"skills": [{
		"id": "fire_ball",
		"name": "火球术"
	}],
	"elements": [],
	"hp": 5
}

func _ready():
	$Systhesis/SysthesisContainer.visible = false
	$Mask.visible = false
	self.ActionPanel.visible = true
	self.SummaryPanel.visible = true
	self.SkillPanel.visible = false
	self.Dialogue.visible = false

func _on_UseSkill_pressed():
	self.Dialogue.visible = false
	self.ActionPanel.visible = false
	self.SummaryPanel.visible = true
	self.SkillPanel.visible = true
	
	NodeUtils.clear_children(SkillList)
	for item in self.state.skills:
		var node = SkillItemScene.instance()
		node.text = item.name
		node.connect("pressed", self, "use_skill", [item])
		self.SkillList.add_child(node)
		

func _on_GenerateSkill_pressed():
	$Systhesis/SysthesisContainer.visible = true
	$Mask.visible = true

func _on_SysthesisBack_pressed():
	$Systhesis/SysthesisContainer.visible = false
	$Mask.visible = false

func _on_SkillPanelBack_pressed():
	self.Dialogue.visible = false
	self.SkillPanel.visible = false
	self.ActionPanel.visible = true
	self.SummaryPanel.visible = true
	
func show_dialogue(content: String):
	self.Dialogue.visible = true
	self.SummaryPanel.visible = false
	self.ActionPanel.visible = false
	self.SkillPanel.visible = false
	
	self.DialogueContent.bbcode_text = content
	yield(self.get_tree().create_timer(2), "timeout")
	
	self.Dialogue.visible = false
	self.SkillPanel.visible = false	
	self.SummaryPanel.visible = true
	self.ActionPanel.visible = true

func use_skill(skill):
	print_debug(skill)
	self.show_dialogue("十三点")


func _on_SysthesisContainer_generate_finished(skill):
	if skill == null:
		return
	if ArrayUtils.find(self.state.skills, skill) != null:
		self._on_SysthesisBack_pressed()
		return
	self.state.skills.push_back(skill)
	
	self._on_SysthesisBack_pressed()
