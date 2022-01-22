extends Node

signal show_sentence(sentence, data)
signal sentence_finished()
signal show_branch(branch, data)
signal branch_selected(option)
signal dialogue_finished(last_item)

var root_dialogue
var last_item

func process_dialogue(dialogue, data = {}):
	var dialogues = dialogue.duplicate(true)
	self.root_dialogue = dialogues
	self._do_process_dialogue(dialogues, data)
	yield(self, "dialogue_finished")

func _do_process_dialogue(dialogue, data = {}):
	var final_dialogue = []
	for item in dialogue:
		final_dialogue.push_back(item)
	for item in final_dialogue:
		if item.type == "branch":
			for option_item in item.options:
				var option = yield(self.process_branch(item, data), "completed")
				yield(self._do_process_dialogue(option.dialogue, data), "completed")
		elif item.type == "sentence":
			yield(self.process_sentence(item), "completed")
	yield(get_tree().create_timer(0.0001), "timeout")
	if self.root_dialogue == dialogue:
		self.emit_signal("dialogue_finished", self.last_item)

func process_sentence(sentence, data = {}):
	sentence.content = self.replace_content_tag(sentence.content, "warning", "[b][color=#FF4040]", "[/color][/b]")
	sentence.content = self.replace_content_tag(sentence.content, "hint", "[b][color=#FF4040][", "][/color][/b]")
	self.emit_signal("show_sentence", sentence, data)
	yield(self, "sentence_finished")

func process_branch(branch, data = {}):
	branch.content = self.replace_content_tag(branch.content, "warning", "[b][color=#FF4040]", "[/color][/b]")
	branch.content = self.replace_content_tag(branch.content, "hint", "[b][color=#FF4040][", "][/color][/b]")	
	self.emit_signal("show_branch", branch, data)
	var option = yield(self, "branch_selected")
	return option

func replace_content_tag(content, tag, tag_start_content, tag_end_content):
	var start = 0
	while content.substr(start).find(tag) != -1:
		var content_str = content.substr(start)
		var startIndex = content_str.find("[" + tag + "]")
		var endIndex = content_str.find("[/" + tag + "]")
		var before_string = content.substr(0, start) if start != 0 else content.substr(0, startIndex)
		var center_string = content_str.substr(startIndex + len("[" + tag + "]"), endIndex - (startIndex + len("[" + tag + "]")))
		center_string = tag_start_content + center_string + tag_end_content
		var after_string = content_str.substr(endIndex + len("[/" + tag + "]"), len(content_str) - endIndex + len("[/" + tag + "]"))
		content = before_string + center_string + after_string
		start += startIndex + len(center_string) + 1
	return content
