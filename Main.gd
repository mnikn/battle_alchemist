extends Node2D

var BattleScene = preload("./Battle.tscn")
var GameOverScene = preload("./game_over/GameOver.tscn")
var DialogueScene = preload("res://components/dialogue/Dialogue.tscn")

func _ready():
	$Mask.visible = false
	yield(self.show_dialogue([{
		"type": "sentence",
		"content": "你叫金,是一个元素炼成师."
	}, {
		"type": "sentence",
		"content": "所谓元素炼成师,就是能够把世界中的物质和精神组合起来的人."
	}, {
		"type": "sentence",
		"content": "最近传闻世界上一个新的魔王出现,众多魔物涌现."
	}, {
		"type": "sentence",
		"content": "为了世界和平,你决定前往魔王的城堡去打倒魔王."
	}, {
		"type": "sentence",
		"actor": "金",
		"portrait": "res://assets/jin.png",
		"content": "能够打倒魔王的,kono 金哒!"
	}]), "completed")
	
	yield(self.show_dialogue([{
		"type": "sentence",
		"content": "来到魔王的城堡后,一只史莱姆挡在你的面前!"
	}]), "completed")
	var slime_battle = self.create_battle(Constants.CREATURES.slime,
	[
		Constants.ELEMENTS.fire, 
		Constants.ELEMENTS.water,
		Constants.ELEMENTS.concentrated,
		Constants.ELEMENTS.concentrated,
		Constants.ELEMENTS.warm
	])
	yield(self.show_dialogue([{
		"type": "sentence",
		"actor": "金",
		"portrait": "res://assets/jin.png",
		"content": "史莱姆吗,我印象中这种生物比较怕火."
	}, {
		"type": "sentence",
		"actor": "金",
		"portrait": "res://assets/jin.png",
		"content": "合成一些火相关的技能应该就能打倒它."
	}]), "completed")
	var slime_win = yield(slime_battle, "battle_finished")
	if !slime_win:
		self.show_game_over()
		return
	
	yield(self.show_dialogue([{
		"type": "sentence",
		"content": "打败史莱姆后,你继续前进."
	}, {
		"type": "sentence",
		"content": "刚走了没多久,一只骷髅从暗处向你袭击!"
	}]), "completed")
	var skeleton_battle = self.create_battle(Constants.CREATURES.skleton, 
	[
		Constants.ELEMENTS.fire, 
		Constants.ELEMENTS.water,
		Constants.ELEMENTS.mud,
		Constants.ELEMENTS.warm,
		Constants.ELEMENTS.concentrated,
		Constants.ELEMENTS.concentrated,
		Constants.ELEMENTS.firm,
		Constants.ELEMENTS.firm,
		Constants.ELEMENTS.crash,
		Constants.ELEMENTS.crash
	])
	yield(self.show_dialogue([{
		"type": "sentence",
		"actor": "金",
		"portrait": "res://assets/jin.png",
		"content": "唔,骷髅这种生物，用火烧还是用水泡对它都没什么影响."
	}, {
		"type": "sentence",
		"actor": "金",
		"portrait": "res://assets/jin.png",
		"content": "最好的方式是让它粉身碎骨,把它骨灰都扬了!或者也可以用更加猛烈的火焰烧到只剩下骨灰."
	}]), "completed")
	var skeleton_win = yield(skeleton_battle, "battle_finished")
	if !skeleton_win:
		self.show_game_over()
		return
	
	yield(self.show_dialogue([{
		"type": "sentence",
		"content": "打败怪物后你继续前进."
	}, {
		"type": "sentence",
		"content": "突然一个巨大的身影出现在你面前---是巨魔.它向你张牙舞爪扑过来!"
	}]), "completed")
	var troll_battle = self.create_battle(Constants.CREATURES.troll, 
	[
		Constants.ELEMENTS.fire, 
		Constants.ELEMENTS.water,
		Constants.ELEMENTS.mud,
		Constants.ELEMENTS.concentrated,
		Constants.ELEMENTS.warm,
		Constants.ELEMENTS.firm,
		Constants.ELEMENTS.wrath,
		Constants.ELEMENTS.crash
	])
	yield(self.show_dialogue([{
		"type": "sentence",
		"actor": "金",
		"portrait": "res://assets/jin.png",
		"content": "我觉得你应该都熟悉该怎么战斗了吧,那接下来我就不用再假装自然自语给你提示了!"
	}]), "completed")
	var troll_win = yield(troll_battle, "battle_finished")
	if !troll_win:
		self.show_game_over()
		return
	
	yield(self.show_dialogue([{
		"type": "sentence",
		"portrait": "res://assets/jin.png",
		"content": "你已经很接近魔王的位置了.当你走到魔王的门前,炎魔出现在你面前."
	}, {
		"type": "sentence",
		"actor": "炎魔",
		"content": "站住!想要打倒魔王的话就要先打败我!"
	}, {
		"type": "sentence",
		"actor": "金",
		"portrait": "res://assets/jin.png",
		"content": "我还以为除了魔王的怪物都不会说话呢!既然你求我打败你,那我就勉为其难和你打一场吧."
	}]), "completed")
	var balrog_battle = self.create_battle(Constants.CREATURES.balrog, 
	[
		Constants.ELEMENTS.fire, 
		Constants.ELEMENTS.water,
		Constants.ELEMENTS.mud,
		Constants.ELEMENTS.concentrated,
		Constants.ELEMENTS.firm,
		Constants.ELEMENTS.crash
	])
	var balrog_win = yield(balrog_battle, "battle_finished")
	if !balrog_win:
		self.show_game_over()
		return
	yield(self.show_dialogue([{
		"type": "sentence",
		"actor": "炎魔",
		"content": "...呵呵,即使你能够打败我,你也没可能打败魔王."
	}, {
		"type": "sentence",
		"actor": "炎魔",
		"content": "魔王甚至可以停止时间!"
	}, {
		"type": "sentence",
		"actor": "金",
		"portrait": "res://assets/jin.png",
		"content": "停止时间吗,这还是挺棘手的,有什么方法能够解决吗."
	}]), "completed")
	
	yield(self.show_dialogue([{
		"type": "sentence",
		"content": "你终于来到魔王面前,魔王看到了你邪魅一笑."
	}, {
		"type": "sentence",
		"actor": "魔王",
		"content": "你终于来到这里了,我还以为这个世界的人都是胆小鬼,没想到还有人敢过来."
	}, {
		"type": "sentence",
		"actor": "金",
		"portrait": "res://assets/jin.png",
		"content": "废话少说,看我过来把你痛揍一顿!"
	}, {
		"type": "sentence",
		"actor": "魔王",
		"content": "非但不逃走,还向我这边走来吗.明明我的守卫都告诉过你我有多可怕了."
	}, {
		"type": "sentence",
		"actor": "金",
		"portrait": "res://assets/jin.png",
		"content": "不走进点的话,怎么痛揍你一顿啊!"
	}, {
		"type": "sentence",
		"actor": "魔王",
		"content": "霍霍,那你就再走进点好了."
	}, {
		"type": "sentence",
		"content": "你和魔王互相走向对方,你们之前发出两股强大的气流相互碰撞,战斗开始!"
	}]), "completed")
	var king_battle = self.create_battle(Constants.CREATURES.king, 
	[
		Constants.ELEMENTS.fire, 
		Constants.ELEMENTS.water,
		Constants.ELEMENTS.mud,
		Constants.ELEMENTS.concentrated,
		Constants.ELEMENTS.crash
	])
	var king_win = yield(king_battle, "battle_finished")
	if !king_win:
		self.show_game_over()
		return
	
func on_battle_finished(win, node: Node):
	node.queue_free()
	yield(node, "tree_exited")
		
func show_game_over():
	var game_over = self.GameOverScene.instance()
	self.add_child(game_over)
	
func create_battle(enemy, elements):
	var battle = self.BattleScene.instance()
	battle.enemy = enemy
	battle.state.elements = elements
	battle.connect("battle_finished", self, "on_battle_finished", [battle])
	self.add_child(battle)
	return battle

func show_dialogue(dialogue):
	$Mask.visible = true
	var node = self.DialogueScene.instance()
	$Popups.add_child(node)
	yield(node.show_dialogue(dialogue), "completed")
	$Mask.visible = false
