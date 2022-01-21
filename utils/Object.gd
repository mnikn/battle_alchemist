extends Node
class_name ObjectUtils


static func get_value(obj, property: String, default_value = null):
	var arr = property.split(".")
	if len(arr) <= 0:
		return null
	return _do_get_value(obj, arr, default_value)

static func _do_get_value(obj, property_arr: PoolStringArray, default_value):
	if len(property_arr) <= 0 or obj == null:
		return default_value
	var tmp = default_value
	if obj.has(property_arr[0]):
		tmp =  obj[property_arr[0]]
	if len(property_arr) == 1:
		return tmp
	
	var sub_arr = []
	for i in range(1, len(property_arr)):
		sub_arr.push_back(property_arr[i])
	return _do_get_value(tmp, sub_arr, default_value)
