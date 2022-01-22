extends DragDropTarget


func can_drop(node):
	return node.data.type == self.get_parent().target_type
		
