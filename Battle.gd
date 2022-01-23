extends Node2D

signal battle_finished(win)

onready var SummaryPanel = $UI/BottomPanel/MarginContainer/HBoxContainer/SummaryPanel
onready var ActionPanel = $UI/BottomPanel/MarginContainer/HBoxContainer/ActionPanel
onready var SkillPanel = $UI/BottomPanel/MarginContainer/HBoxContainer/SkillPanel
onready var SkillList = $UI/BottomPanel/MarginContainer/HBoxContainer/SkillPanel/MarginContainer/GridContainer
onready var Dialogue = $UI/BottomPanel/MarginContainer/HBoxContainer/Dialogue
onready var DialogueContent = $UI/BottomPanel/MarginContainer/HBoxContainer/Dialogue/MarginContainer/Content

onready var SkillItemScene = preload("res://SkillItem.tscn")

export (Dictionary) var enemy

const DAMAGE_DIALOGUE = "{enemy}向你发起攻击,你受到 {damage} 点伤害!"
const LOSE_DIALOGUE = "你倒下了!"
const ENEMY_DAMAGE_DIALOGUE = "你发动技能{skill},对{enemy}造成 {damage} 点伤害!"
const ENEMY_DEFEATED = "{enemy}倒下了,你打败了{enemy}!"
const HEAL = "你发动技能{skill},恢复了 {value} 点 hp!"
const DEFENSE = "你发动技能{skill},接下来受到的伤害会减少 {value}!"
const ATTACK = "你发动技能{skill},接下来攻击伤害增加 {value}!"

var state = {
	"skills": [],
	"elements": [],
	"hp": {
		"max_hp": 20,
		"current_hp": 20
	},
	"buffer_skills": {}
}

func _ready():
	$Systhesis/SysthesisContainer.visible = false
	$Mask.visible = false
	self.ActionPanel.visible = true
	self.SummaryPanel.visible = true
	self.SkillPanel.visible = false
	self.Dialogue.visible = false
	
	$UI/PanelContainer/MarginContainer/VBoxContainer/Hp.init(self.state.hp)
	
	$Canvas/Enemy/Portrait.texture = load(self.enemy.portrait)
	
	if self.enemy.id != "king":
		$NormalPlayer.play()
	else:
		$BossPlayer.play()

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
		if skill.id in self.enemy.weak:
			damage = skill.critical_damage
		elif skill.id in self.enemy.strong:
			damage = skill.weak_damage
		for item in self.state.buffer_skills.values():
			if item.has("attack"):
				damage += item.attack
		self.enemy.hp.current_hp -= damage
		yield(self.show_dialogue(ENEMY_DAMAGE_DIALOGUE.format({
			"enemy": self.enemy.name,
			"skill": skill.name,
			"damage": damage
		})), "completed")
		if self.enemy.hp.current_hp <= 0:
			yield(self.show_dialogue(ENEMY_DEFEATED.format({
				"enemy": self.enemy.name
			})), "completed")
			self.emit_signal("battle_finished", true)
			return
	elif skill.type == "heal":
		var origin_hp = self.state.hp.current_hp
		self.state.hp.current_hp = min(self.state.hp.current_hp + skill.heal, self.state.hp.max_hp)
		var hp_change = self.state.hp.current_hp - origin_hp
		$UI/PanelContainer/MarginContainer/VBoxContainer/Hp.init(self.state.hp)
		yield(self.show_dialogue(HEAL.format({
			"skill": skill.name,
			"value": hp_change
		})), "completed")
	elif skill.type == "buffer":
		self.state.buffer_skills[skill.id] = skill
		var BufferList = $UI/BottomPanel/MarginContainer/HBoxContainer/SummaryPanel/MarginContainer/VBoxContainer/VBoxContainer
		NodeUtils.clear_children(BufferList)
		for item in self.state.buffer_skills.values():
			var node = Label.new()
			node.set("custom_colors/font_color", Color("#000"))
			if item.has("defense"):
				node.text = "{skill}:受到的伤害减少 {value}".format({
					"skill": item.name,
					"value": item.defense
				})
			elif item.has("attack"):
				node.text = "{skill}:攻击伤害增加 {value}".format({
					"skill": item.name,
					"value": item.attack
				})
			BufferList.add_child(node)
		if skill.has("defense"):
			yield(self.show_dialogue(DEFENSE.format({
				"skill": skill.name,
				"value": skill.defense
			})), "completed")
		elif skill.has("attack"):
			yield(self.show_dialogue(ATTACK.format({
				"skill": skill.name,
				"value": skill.attack
			})), "completed")
	self.next_term()

func _on_SysthesisContainer_generate_finished(skill, physic, mental):
	self._on_SysthesisBack_pressed()
	$UI/BottomPanel/MarginContainer/HBoxContainer/ActionPanel/MarginContainer/VBoxContainer/GenerateSkill.disabled = true
	if skill == null:
		return
	if ArrayUtils.find(self.state.skills, { "id": skill.id}) != null:
		return

	var skill_res = []
	for item in self.state.skills:
		if item.id != physic.id:
			skill_res.push_back(item)
		else:
			physic = {"id": ""}
	self.state.skills = skill_res
	
	var element_res = []
	for item in self.state.elements:
		if item.id != physic.id and item.id != mental.id:
			element_res.push_back(item)
		elif item.id == physic.id:
			physic = {"id": ""}
		elif item.id == mental.id:
			mental = {"id": ""}
	self.state.elements = element_res
	
	self.state.skills.push_back(skill)
	
func show_action_panel():
	self.Dialogue.visible = false
	self.SkillPanel.visible = false
	self.ActionPanel.visible = true
	self.SummaryPanel.visible = true
	
func next_term():
	$UI/BottomPanel/MarginContainer/HBoxContainer/ActionPanel/MarginContainer/VBoxContainer/GenerateSkill.disabled = false
	var damage = round(RandomUtils.dice_range(self.enemy.attack))
	var defense = 0
	for item in self.state.buffer_skills.values():
		if item.has("defense"):
			defense += item.defense
	damage = max(damage - defense, 0)
	var origin_hp = self.state.hp.current_hp
	self.state.hp.current_hp = max(self.state.hp.current_hp - damage, 0)
	
	yield(self.show_dialogue(DAMAGE_DIALOGUE.format({
		"enemy": self.enemy.name,
		"damage": abs(damage)
	})), "completed")
	$UI/PanelContainer/MarginContainer/VBoxContainer/Hp.init(self.state.hp)
	
	if self.state.hp.current_hp <= 0:
		yield(self.show_dialogue(LOSE_DIALOGUE), "completed")
		self.emit_signal("battle_finished", false)
		return
	if self.enemy.id == "king":
		pass
	self.show_action_panel()
	
