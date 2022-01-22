extends DragDropTarget


func can_drop(node):
	if self.get_parent().target_type == "physic":
		return Constants.SKILLS.has(node.data.id) or node.data.type == self.get_parent().target_type
	return node.data.type == self.get_parent().target_type
		
