extends PopupDialog

signal sentence_all_visible(sentence)
signal sentence_confirmed(sentence)
signal dialogue_finished(last_sentence)
signal branch_selected(branch_id)
signal combat_finished()

onready var Content = $Layout/MarginContainer/Layout/Layout/Content
onready var Indictor = $Layout/Indictor
onready var PortraitContainer = $Layout/MarginContainer/Layout/PortraitContainer
onready var Portrait = $Layout/MarginContainer/Layout/PortraitContainer/MarginContainer/Portrait
onready var Actor = $Layout/MarginContainer/Layout/Layout/Actor
onready var Options = $Layout/MarginContainer/Layout/Layout/Options
var OptionButtonScene = preload("./OptionButton.tscn")

const text_speed = 0.02
const skip_text_speed = 0.2
var current_dialogue_item
var enabled = true setget set_enabled

func _ready():
	pass

func show_dialogue(dialogue, data = {}):
	self.popup(Rect2(self.rect_position, self.rect_size))
	yield($Logic.process_dialogue(dialogue, data), "completed")
	self.queue_free()

func set_enabled(value):
	self.set_process_input(value)
	if value:
		self.show()
	else:
		self.hide()

func _input(event):
	if !enabled or self.current_dialogue_item == null or self.current_dialogue_item.type == "branch":
		return
	if event.is_action_pressed("ui_accept") and self.Content.percent_visible == 1:
		self.emit_signal("sentence_confirmed", self.current_dialogue_item)
	elif event.is_action_pressed("ui_accept") and self.Content.percent_visible != 1:
		self.Content.percent_visible = 1
		self.emit_signal("sentence_all_visible")

func _on_Logic_show_sentence(sentence, data):
	self.current_dialogue_item = sentence
	self.Indictor.visible = false
	$AnimationPlayer.stop(true)
	self.Actor.visible = false
	self.PortraitContainer.visible = false
	for item in self.Options.get_children():
		self.Options.remove_child(item)
	self.Content.visible = true
	
	var content = sentence.content
	if sentence.has("actor"):
		if content.find("%talk_end") != -1:
			content = content.replace("%talk_end", "]")
			content = "[" + content
		else:
			content = "【" + content + "】"
		self.Actor.text = sentence.actor
		self.Actor.visible = true
	if sentence.has("portrait"):
		self.PortraitContainer.visible = true
		self.Portrait.texture = load(sentence.portrait)

	for key in data:
		content = content.replace("{{" + key + "}}", data[key])
	self.Content.bbcode_text = content
	self.Content.percent_visible = 0

	$Timer.start()
	yield(self, "sentence_all_visible")
	yield(self, "sentence_confirmed")
	$Logic.emit_signal("sentence_finished")

func _on_Logic_show_branch(branch, data) -> void:
	self.current_dialogue_item = branch
	self.Indictor.visible = false
	$AnimationPlayer.stop(true)
	self.Actor.visible = false
	self.PortraitContainer.visible = false
	NodeUtils.remove_children(self.Options)

	self.Content.visible = true
	var content = branch.content
	for key in data:
		content.replace("{{" + key + "}}", data[key])
	self.Content.bbcode_text = content
	self.Content.percent_visible = 0

	$Timer.start()
	yield(self, "sentence_all_visible")
	for option in branch.options:
		var node = OptionButtonScene.instance()
		node.text = option.content
		if option.has("disabled") and option.disabled:
			node.disabled = true
		node.connect("pressed", self, "_option_button_pressed", [option])
		self.Options.add_child(node)
	self.Options.get_children()[0].grab_focus()
#
func _option_button_pressed(option):
	$Logic.emit_signal("branch_selected", option)
	self.emit_signal("branch_selected", option.id)

func _on_Timer_timeout():
	if Input.get_action_strength("skip_dialogue") and !(self.current_dialogue_item.type == "branch"):
		self.Content.percent_visible = max(self.Content.percent_visible, self.Content.percent_visible + skip_text_speed)
	else:
		self.Content.percent_visible = max(self.Content.percent_visible, self.Content.percent_visible + text_speed)
	if self.Content.percent_visible == 1 or len(self.current_dialogue_item.content) == 0:
		if len(self.current_dialogue_item.content) == 0:
			yield(self.get_tree().create_timer(0.1), "timeout")
		$Timer.stop()
		if !(self.current_dialogue_item.type == "branch"):
			self.Indictor.visible = true
			$AnimationPlayer.play("show_indictor")
		self.emit_signal("sentence_all_visible")
	else:
		$Timer.start()
