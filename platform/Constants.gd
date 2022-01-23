extends Node

const SKILLS = {
	"fire_ball": {
		"id": "fire_ball",
		"type": "attack",
		"name": "火球术",
		"weak_damage": 1,
		"normal_damage": 2,
		"critical_damage": 5
	},
	"fire_missile": {
		"id": "fire_ball",
		"type": "attack",
		"name": "火弹术",
		"weak_damage": 1,
		"normal_damage": 2,
		"critical_damage": 5
	},
	"fire_attack": {
		"id": "fire_attack",
		"type": "buffer",
		"name": "炙热能量",
		"attack": 2,
	},
	"big_fire_attack": {
		"id": "big_fire_attack",
		"type": "buffer",
		"name": "灼热力量",
		"attack": 5
	},
	"fire_whip": {
		"id": "fire_whip",
		"type": "attack",
		"name": "火鞭",
		"weak_damage": 2,
		"normal_damage": 3,
		"critical_damage": 6
	},
	"big_fire_ball": {
		"id": "big_fire_ball",
		"type": "attack",
		"name": "豪火球术",
		"weak_damage": 3,
		"normal_damage": 5,
		"critical_damage": 10
	},
	"fire_rain": {
		"id": "fire_ball",
		"type": "attack",
		"name": "火雨",
		"weak_damage": 5,
		"normal_damage": 10,
		"critical_damage": 20
	},
	
	"water_ball": {
		"id": "water_ball",
		"type": "attack",
		"name": "水球术",
		"weak_damage": 1,
		"normal_damage": 2,
		"critical_damage": 5
	},
	"big_rain": {
		"id": "big_rain",
		"type": "attack",
		"name": "暴雨术",
		"weak_damage": 3,
		"normal_damage": 5,
		"critical_damage": 10
	},
	"heal": {
		"id": "heal",
		"type": "heal",
		"name": "治愈术",
		"heal": 5
	},
	"big_heal": {
		"id": "big_heal",
		"type": "heal",
		"name": "痊愈术",
		"heal": 20
	},
	
	"stone_crash": {
		"id": "stone_crash",
		"type": "attack",
		"name": "落石",
		"weak_damage": 1,
		"normal_damage": 2,
		"critical_damage": 10
	},
	"stone_spike": {
		"id": "stone_crash",
		"type": "attack",
		"name": "土锥术",
		"weak_damage": 1,
		"normal_damage": 2,
		"critical_damage": 5
	},
	"stone_shield": {
		"id": "stone_shield",
		"type": "buffer",
		"name": "土墙术",
		"defense": 2
	},
	"big_stone_shield": {
		"id": "big_stone_shield",
		"type": "buffer",
		"name": "土壳术",
		"defense": 5
	}
}


const ELEMENTS = {
	"fire": {
		"type": "physic",
		"id": "fire",
		"name": "火"
	},
	"water": {
		"type": "physic",
		"id": "water",
		"name": "水"
	},
	"mud": {
		"type": "physic",
		"id": "mud",
		"name": "土"
	},
	
	"concentrated": {
		"type": "mental",
		"id": "concentrated",
		"name": "专注"
	},
	"crash": {
		"type": "mental",
		"id": "crash",
		"name": "崩溃"
	},
	"firm": {
		"type": "mental",
		"id": "firm",
		"name": "猛烈"
	},
	"warm": {
		"type": "mental",
		"id": "warm",
		"name": "柔和"
	},
	"wrath": {
		"type": "mental",
		"id": "wrath",
		"name": "愤怒"
	}
}

const GENERATE_SKILL_TABLE = [
	["fire", "concentrated", "fire_ball"],
	["fire", "firm", "fire_missile"],
	["fire", "warm", "fire_attack"],
	["fire_attack", "warm", "big_fire_attack"],
	["fire", "wrath", "fire_whip"],
	["fire_ball", "firm", "big_fire_ball"],
	["big_fire_ball", "firm", "fire_rain"],
	
	["water", "warm", "heal"],
	["heal", "concentrated", "big_heal"],
	["water", "concentrated", "water_ball"],
	["water", "firm", "water_ball"],
	["water", "firm", "big_rain"],
	["water_ball", "firm", "big_rain"],
	
	["mud", "concentrated", "stone_pike"],
	
	["mud", "crash", "stone_crash"],
	["mud", "warm", "stone_shield"],
	["stone_shield", "firm", "big_stone_shield"],
	
	["mud", "cool", "petrification"],
	["ice", "cool", "frezz"]
]

const CREATURES = {
	"slime": {
		"id": "slime",
		"name": "史莱姆",
		"hp": {
			"max_hp": 3,
			"current_hp": 3
		},
		"weak": ["fire_ball", "fire_missile", "big_fire_ball", "fire_rain"],
		"strong": ["water_ball", "big_rain"],
		"attack": [1,1],
		"portrait": "res://assets/creatures/slime.png"
	},
	"skleton": {
		"id": "skleton",
		"name": "骷髅",
		"hp": {
			"max_hp": 10,
			"current_hp": 10
		},
		"weak": ["stone_crash"],
		"strong": ["fire_ball"],
		"attack": [2,4],
		"portrait": "res://assets/creatures/skleton.png"
	},
	"troll": {
		"id": "troll",
		"name": "巨魔",
		"hp": {
			"max_hp": 20,
			"current_hp": 20
		},
		"weak": ["fire_ball", "big_fire_ball"],
		"strong": [],
		"attack": [3,6],
		"portrait": "res://assets/creatures/slime.png"
	},
	"balrog": {
		"id": "balrog",
		"name": "炎魔",
		"hp": {
			"max_hp": 50,
			"current_hp": 50
		},
		"weak": ["water_ball", "big_rain"],
		"strong": ["fire_ball", "big_fire_ball"],
		"attack": [4,7],
		"portrait": "res://assets/creatures/slime.png"
	},
	"king": {
		"id": "king",
		"name": "魔王",
		"hp": {
			"max_hp": 100,
			"current_hp": 100
		},
		"attack": [6,10],
		"weak": [],
		"strong": [],
		"portrait": "res://assets/creatures/slime.png"
	}
}
