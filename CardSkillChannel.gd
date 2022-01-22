extends PanelContainer
signal snap_change()

export (String) var target_type = "" 

func _on_DragDropTarget_on_snap_node(node):
	self.emit_signal("snap_change")

func _on_DragDropTarget_on_snap_remove(node):
	self.emit_signal("snap_change")
