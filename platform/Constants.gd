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
	"fire_cloud": {
		"id": "fire_cloud",
		"type": "attack",
		"name": "火云",
		"weak_damage": 5,
		"normal_damage": 10,
		"critical_damage": 15
	},
	"fire_wrath_spash": {
		"id": "fire_wrath_spash",
		"type": "attack",
		"name": "愤怒喷射",
		"weak_damage": 1,
		"normal_damage": 5,
		"critical_damage": 20
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
	
	# water
	"water_ball": {
		"id": "water_ball",
		"type": "attack",
		"name": "水球术",
		"weak_damage": 1,
		"normal_damage": 2,
		"critical_damage": 5
	},
	"big_water_ball": {
		"id": "big_water_ball",
		"type": "attack",
		"name": "水龙弹术",
		"weak_damage": 2,
		"normal_damage": 5,
		"critical_damage": 15
	},
	"water_drop": {
		"id": "water_drop",
		"type": "attack",
		"name": "瀑布",
		"weak_damage": 3,
		"normal_damage": 6,
		"critical_damage": 18
	},
	"water_flood": {
		"id": "water_flood",
		"type": "attack",
		"name": "大洪灾",
		"weak_damage": 3,
		"normal_damage": 7,
		"critical_damage": 13
	},
	"big_rain": {
		"id": "big_rain",
		"type": "attack",
		"name": "暴雨术",
		"weak_damage": 5,
		"normal_damage": 10,
		"critical_damage": 20
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
	
	# stone
	"stone_spike": {
		"id": "stone_spike",
		"type": "attack",
		"name": "土锥术",
		"weak_damage": 1,
		"normal_damage": 2,
		"critical_damage": 5
	},
	"big_stone_spike": {
		"id": "big_stone_spike",
		"type": "attack",
		"name": "土锥雨术",
		"weak_damage": 3,
		"normal_damage": 5,
		"critical_damage": 15
	},
	"stone_erathquake": {
		"id": "stone_erathquake",
		"type": "attack",
		"name": "地震术",
		"weak_damage": 5,
		"normal_damage": 8,
		"critical_damage": 20
	},
	"stone_erath_spash": {
		"id": "stone_erath_spash",
		"type": "attack",
		"name": "地裂术",
		"weak_damage": 3,
		"normal_damage": 5,
		"critical_damage": 15
	},
	"stone_crash": {
		"id": "stone_crash",
		"type": "attack",
		"name": "落石",
		"weak_damage": 5,
		"normal_damage": 10,
		"critical_damage": 20
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
		"name": "冲动"
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
	["fire_ball", "concentrated", "big_fire_ball"],
	["fire_ball", "firm", "fire_cloud"],
	["fire_ball", "crash", "fire_rain"],
	["fire_ball", "wrath", "fire_wrath_spash"],
	["fire", "warm", "fire_attack"],
	["fire_attack", "warm", "big_fire_attack"],
	["fire", "wrath", "fire_wrath_spash"],
	["fire", "firm", "fire_cloud"],
	["fire", "crash", "fire_rain"],
	
	["water", "concentrated", "water_ball"],
	["water_ball", "concentrated", "big_water_ball"],
	["water_ball", "firm", "water_drop"],
	["water_ball", "wrath", "water_flood"],
	["water_ball", "crash", "big_rain"],
	["water", "warm", "heal"],
	["heal", "concentrated", "big_heal"],
	["water", "wrath", "water_ball"],
	["water", "firm", "water_ball"],
	["water", "crash", "big_rain"],
	
	["mud", "concentrated", "stone_spike"],
	["stone_spike", "concentrated", "big_stone_spike"],
	["stone_spike", "firm", "stone_erath_spash"],
	["stone_spike", "crash", "stone_crash"],
	["stone_spike", "wrath", "stone_erathquake"],
	["mud", "warm", "stone_shield"],
	["stone_shield", "concentrated", "big_stone_shield"],
	["mud", "wrath", "stone_spike"],
	["mud", "firm", "stone_spike"],
	["mud", "crash", "stone_crash"],
]

const CREATURES = {
	"slime": {
		"id": "slime",
		"name": "史莱姆",
		"hp": {
			"max_hp": 3,
			"current_hp": 3
		},
		"weak": ["fire_ball", "big_fire_ball", "fire_rain", "fire_cloud", "fire_wrath_spash"],
		"strong": ["water_ball", "big_rain", "big_water_ball", "water_drop", "water_flood"],
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
		"weak": ["stone_spike", "big_stone_spike", "stone_erath_spash", "stone_crash", "stone_erathquake"],
		"strong": [
			"fire_ball", "big_fire_ball", "fire_rain", "fire_cloud", "fire_wrath_spash",
			"water_ball", "big_rain", "big_water_ball", "water_drop", "water_flood"
		],
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
		"weak": ["fire_ball", "big_fire_ball", "fire_rain", "fire_cloud", "fire_wrath_spash"],
		"strong": [],
		"attack": [3,6],
		"portrait": "res://assets/creatures/troll.png"
	},
	"balrog": {
		"id": "balrog",
		"name": "炎魔",
		"hp": {
			"max_hp": 50,
			"current_hp": 50
		},
		"weak": ["water_ball", "big_rain", "big_water_ball", "water_drop", "water_flood"],
		"strong": ["fire_ball", "big_fire_ball", "fire_rain", "fire_cloud", "fire_rain", "fire_wrath_spash"],
		"attack": [4,7],
		"portrait": "res://assets/creatures/fireman.png"
	},
	"king": {
		"id": "king",
		"name": "魔王",
		"hp": {
			"max_hp": 100,
			"current_hp": 100
		},
		"attack": [5,8],
		"weak": [],
		"strong": [],
		"portrait": "res://assets/creatures/king.png"
	}
}
