extends Node
class_name RandomUtils

static func dice(rate: float) -> bool:
	randomize()
	return randf() < rate

static func dice_range(arr: Array) -> float:
	randomize()
	var min_v = ceil(arr[0]);
	var max_v = floor(arr[1]);
	return floor(randf() * (max_v - min_v + 1)) + min_v
