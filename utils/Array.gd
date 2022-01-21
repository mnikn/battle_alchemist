extends Node
class_name ArrayUtils

static func filter(arr: Array, prop: Dictionary) -> Array:
	var res = []
	for item in arr:
		for key in prop.keys():
			if prop[key] is Array and item[key] in prop[key]:
				res.push_back(item)
			elif (!prop[key] is Array) and prop[key] == item[key]:
				res.push_back(item)
	return res

static func find(arr: Array, prop: Dictionary):
	var res = filter(arr, prop)
	if len(res) == 0:
		return null
	return res[0]

static func join(arr: PoolStringArray, code: String):
	var res = ""
	for item in arr:
		if len(item) > 0:
			res += item + code
	return res.substr(0, len(res) - len(code)) 
