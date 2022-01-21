extends Node2D
class_name Draggable

export (String) var target_group
export (bool) var reset_when_target_out = true
var selected = false
var snaping_node = null
var start_diff: Vector2
var initial_pos = null
onready var parent = self.get_parent()
signal snap_to_target(target)
signal snap_to_initial_pos()

const TOLEARNCE_DISTANCE = 75

func _ready():
	var parent = self.get_parent()
	if not parent is Control:
		printerr("Parent must be a control!")
		return
	var control_children = []
	self.get_control_children(parent, control_children)
	self.get_parent().connect("gui_input", self, "on_control_gui_input")
	for node in control_children:
		node.connect("gui_input", self, "on_control_gui_input")

func get_control_children(node: Node, arr: Array):
	if node == null:
		return arr
	for child in node.get_children():
		if child is Control:
			arr.push_back(child)
		if child.get_child_count() > 0:
			self.get_control_children(child, arr)
	return arr

func _physics_process(delta):
	if not self.get_parent() is Control:
		printerr("Parent must be a control!")
		return
	if self.selected:
		var target_pos = Vector2(self.get_parent().get_global_mouse_position().x - self.start_diff.x,self.get_parent().get_global_mouse_position().y - self.start_diff.y)
		self.get_parent().rect_global_position = lerp(self.get_parent().rect_global_position, target_pos, 40 * delta)

func on_control_gui_input(event):
	if Input.is_action_just_pressed("ui_click"):
		self.selected = true
		if self.initial_pos == null:
			self.initial_pos = self.get_parent().rect_global_position
		self.start_diff = Vector2(self.get_global_mouse_position().x - self.get_parent().rect_global_position.x, self.get_global_mouse_position().y - self.get_parent().rect_global_position.y)
		
		var item = self.get_parent().get_canvas_item()
		VisualServer.canvas_item_set_z_index(item, 1)
				
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		self.selected = false
		var res = self.get_target_distance()
		if res == null:
			return
		var initial_pos_distance = self.get_parent().rect_global_position.distance_to(self.initial_pos)
		if self.snaping_node != null and initial_pos_distance < TOLEARNCE_DISTANCE:
			var dropdrag_handle = res.target.get_node("DragDropTarget")
			if dropdrag_handle != null:
				dropdrag_handle.remove_snap_node(self)
				self.emit_signal("snap_to_initial_pos")
		elif res.distance < TOLEARNCE_DISTANCE:
			if self.snaping_node != null:
				var dropdrag_handle = self.snaping_node.get_node("DragDropTarget")
				if dropdrag_handle != null:
					dropdrag_handle.remove_snap_node(self)
			var dropdrag_handle = res.target.get_node("DragDropTarget")
			if dropdrag_handle != null:
				var success = dropdrag_handle.add_snap_node(self)
				if success:
					self.emit_signal("snap_to_target", res.target)
		else:
			if self.snaping_node != null:
				var target_distance = self.get_parent().rect_global_position.distance_to(self.snaping_node.rect_global_position)
				if self.reset_when_target_out and target_distance > TOLEARNCE_DISTANCE:
					var dropdrag_handle = self.snaping_node.get_node("DragDropTarget")
					if dropdrag_handle != null:
						dropdrag_handle.remove_snap_node(self)
						self.emit_signal("snap_to_initial_pos")
				else:
					self.snap_to_position(self.snaping_node.rect_global_position)
			else:
				self.snap_to_position(self.initial_pos)
				self.emit_signal("snap_to_initial_pos")

func get_target_distance():
	var target_nodes = self.get_tree().get_nodes_in_group(self.target_group)
	if len(target_nodes) <= 0:
		return null
	var shorest_res = {"distance": 999999, "target": null}
	for node in self.get_tree().get_nodes_in_group(self.target_group):
		var distance = self.get_parent().rect_global_position.distance_to(node.rect_global_position)
		if shorest_res.distance > distance:
			shorest_res.distance = distance
			shorest_res.target = node
	return shorest_res

func snap_to_position(pos: Vector2):
	var item = self.get_parent().get_canvas_item()
	VisualServer.canvas_item_set_z_index(item, 1)
	
	var tween = Tween.new()
	tween.interpolate_property(self.get_parent(), "rect_global_position", self.get_parent().rect_global_position, pos, 0.1)
	self.add_child(tween)
	tween.start()
	yield(tween,"tween_all_completed")
	tween.queue_free()
	VisualServer.canvas_item_set_z_index(item, 0)

func snap_to_origin_pos():
	var target_pos = self.snaping_node.rect_global_position if self.snaping_node != null else self.initial_pos
	self.snap_to_position(target_pos)
