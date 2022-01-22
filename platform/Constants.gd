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
	"water_ball": {
		"id": "water_ball",
		"type": "attack",
		"name": "水球术",
		"weak_damage": 1,
		"normal_damage": 2,
		"critical_damage": 5
	},
	"stone_crash": {
		"id": "stone_crash",
		"type": "attack",
		"name": "落石术",
		"weak_damage": 1,
		"normal_damage": 2,
		"critical_damage": 5
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
		"name": "集中"
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
	}
}

const GENERATE_SKILL_TABLE = {
	"fire_ball": ["fire", "concentrated"],
	"stone_crash": ["mud", "crash"],
	"big_fire_ball": ["fire_ball", "firm"],
	"water_ball": ["water", "concentrated"],
	"big_rain": ["water_ball", "firm"],
	"petrification": ["mud", "cool"],
	"frezz": ["ice", "cool"],
	"last_light": ["human", "courage"]
}

const CREATURES = {
	"slime": {
		"id": "slime",
		"name": "史莱姆",
		"hp": {
			"max_hp": 3,
			"current_hp": 3
		},
		"weak": ["fire_ball"],
		"strong": ["water_ball"],
		"attack": [1,1]
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
		"attack": [2,4]
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
		"attack": [3,6]
	},
	"balrog": {
		"id": "balrog",
		"name": "炎魔",
		"hp": {
			"max_hp": 50,
			"current_hp": 50
		},
		"weak": [],
		"strong": [],
		"attack": [4,7]
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
	}
}
