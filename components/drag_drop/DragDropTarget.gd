extends Node
class_name DragDropTarget

signal on_snap_node(node)
signal on_snap_remove(node)

var snap_nodes = []
export (bool) var snap_node_exclude = true

func remove_snap_node(node: Draggable):
	node.snap_to_position(node.initial_pos)
	node.snaping_node = null
	self.snap_nodes.remove(self.snap_nodes.find(node))
	self.emit_signal("on_snap_remove", node.get_parent())

func remove_all_snap():
	for node in self.snap_nodes:
		self.remove_snap_node(node)
	
func add_snap_node(node: Draggable):
	if !self.can_drop(node.get_parent()):
		node.snap_to_origin_pos()
		return false
	if self.snap_nodes.find(node) == -1:
		self.snap_nodes.append(node)
	node.snaping_node = self.get_parent()
	node.snap_to_position(self.get_parent().rect_global_position)
	if self.snap_node_exclude:
		var res = ArrayUtils.concat(self.snap_nodes, [])
		for snap_node in res:
			if snap_node != node:
				snap_node.snap_to_position(snap_node.initial_pos)
				self.snap_nodes.remove(self.snap_nodes.find(snap_node))
	self.emit_signal("on_snap_node", node.get_parent())	
	return true

func can_drop(node):
	return true
