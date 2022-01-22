extends Node2D

signal battle_finished(win)

onready var SummaryPanel = $UI/BottomPanel/MarginContainer/HBoxContainer/SummaryPanel
onready var ActionPanel = $UI/BottomPanel/MarginContainer/HBoxContainer/ActionPanel
onready var SkillPanel = $UI/BottomPanel/MarginContainer/HBoxContainer/SkillPanel
onready var SkillList = $UI/BottomPanel/MarginContainer/HBoxContainer/SkillPanel/MarginContainer/GridContainer
onready var Dialogue = $UI/BottomPanel/MarginContainer/HBoxContainer/Dialogue
onready var DialogueContent = $UI/BottomPanel/MarginContainer/HBoxContainer/Dialogue/MarginContainer/Content

onready var SkillItemScene = preload("res://SkillItem.tscn")

export (Dictionary) var enmey

const DAMAGE_DIALOGUE = "{enemy}向你发起攻击,你受到 {damage} 点伤害!"
const LOSE_DIALOGUE = "你倒下了!"
const ENEMY_DAMAGE_DIALOGUE = "你发动技能{skill},对{enemy}造成 {damage} 点伤害!"
const ENEMY_DEFEATED = "{enemy}倒下了,你打败了{enemy}!"

var state = {
	"skills": [],
	"elements": [Constants.ELEMENTS.fire, Constants.ELEMENTS.firm],
	"hp": {
		"max_hp": 20,
		"current_hp": 20
	}
}


func _ready():
	$Systhesis/SysthesisContainer.visible = false
	$Mask.visible = false
	self.ActionPanel.visible = true
	self.SummaryPanel.visible = true
	self.SkillPanel.visible = false
	self.Dialogue.visible = false
	
	$UI/PanelContainer/MarginContainer/VBoxContainer/Hp.init(self.state.hp)

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
	$Systhesis/SysthesisContainer.elements = ArrayUtils.concat(self.state.elements, self.state.skills)
	$Systhesis/SysthesisContainer.visible = true
	$Mask.visible = true

func _on_SysthesisBack_pressed():
	$Systhesis/SysthesisContainer.visible = false
	$Mask.visible = false

func _on_SkillPanelBack_pressed():
	self.show_action_panel()
	
func show_dialogue(content: String):
	self.Dialogue.visible = true
	self.SummaryPanel.visible = false
	self.ActionPanel.visible = false
	self.SkillPanel.visible = false
	
	self.DialogueContent.bbcode_text = content
	yield(self.get_tree().create_timer(1.5), "timeout")
	
	self.show_action_panel()

func use_skill(skill):
	if skill.type == "attack":
		var damage = skill.normal_damage
		if skill.id in self.enmey.weak:
			damage = skill.critical_damage
		elif skill.id in self.enmey.strong:
			damage = skill.weak_damage
		self.enmey.hp.current_hp -= damage
		yield(self.show_dialogue(ENEMY_DAMAGE_DIALOGUE.format({
			"enemy": self.enmey.name,
			"skill": skill.name,
			"damage": damage
		})), "completed")
		if self.enmey.hp.current_hp <= 0:
			yield(self.show_dialogue(ENEMY_DEFEATED.format({
				"enemy": self.enmey.name
			})), "completed")
			self.emit_signal("battle_finished", true)
			return
		
	self.next_term()

func _on_SysthesisContainer_generate_finished(skill):
	self._on_SysthesisBack_pressed()
	if skill == null:
		self.next_term()
		return
	if ArrayUtils.find(self.state.skills, skill) != null:
		self.next_term()
		return
	self.state.skills.push_back(skill)
	
	self.next_term()
	
func show_action_panel():
	self.Dialogue.visible = false
	self.SkillPanel.visible = false
	self.ActionPanel.visible = true
	self.SummaryPanel.visible = true
	
func next_term():
	var damage = round(RandomUtils.dice_range(self.enmey.attack))
	var origin_hp = self.state.hp.current_hp
	self.state.hp.current_hp = max(self.state.hp.current_hp - damage, 0)
	
	yield(self.show_dialogue(DAMAGE_DIALOGUE.format({
		"enemy": self.enmey.name,
		"damage": abs(damage)
	})), "completed")
	$UI/PanelContainer/MarginContainer/VBoxContainer/Hp.init(self.state.hp)
	
	if self.state.hp.current_hp <= 0:
		yield(self.show_dialogue(LOSE_DIALOGUE), "completed")
		self.emit_signal("battle_finished", false)
		return
	if self.enmey.id == "king":
		pass
	self.show_action_panel()
	
