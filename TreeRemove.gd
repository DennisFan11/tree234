class_name TreeRemove extends TreeCRUD

static var _root:TreeNode
var _insert_instance:TreeInsert = TreeInsert.new()

## interface NOTE 函數簽名不允許更動
func remove(root:TreeNode, remove_val:float) -> TreeNode:
	return _remove_BST(root, remove_val)


func _remove_BST(node:TreeNode, val:float) -> TreeNode: # TODO BST的remove只充當佔位符
	_insert_instance.dr(node)
	if node == null:
		return null
	if val == node.val:
		return check(node)  # 返回刪除後的新子樹根
	elif val < node.val:
		if node.L:
			node.L = _remove_BST(node.L, val)  # 更新左子樹
	else:
		if node.R:
			node.R = _remove_BST(node.R, val)  # 更新右子樹
	return node  # 返回當前節點


func check(node:TreeNode) -> TreeNode:
	if !child(node):  # 葉節點，直接刪除
		re(node)
		return null  # 該子樹變為空
	else:  # 有左右子節點
		var successor:TreeNode
		if laynL(node.L) == -2:
			successor = _find_minR(node.R)
			node.val = successor.val  # 替換當前節點的值
			node.R = _remove_BST(node.R, successor.val)  # 刪除繼任節點
		elif laynR(node.R) == -2:
			successor = _find_minL(node.L)
			node.val = successor.val  # 替換當前節點的值
			node.L = _remove_BST(node.L, successor.val)  # 刪除繼任節點
		elif laynL(node.L) < laynR(node.R):
			successor = _find_minL(node.L)
			node.val = successor.val  # 替換當前節點的值
			node.L = _remove_BST(node.L, successor.val)  # 刪除繼任節點
			print(node.val)
		else:
			successor = _find_minR(node.R)
			node.val = successor.val  # 替換當前節點的值
			node.R = _remove_BST(node.R, successor.val)  # 刪除繼任節點
			print(node.val)
		return node  # 返回當前節點

func re(node:TreeNode):
	if node.color == RED: #紅的直接刪除
		_delete_treeNode(node)
	elif !node.P and !child(node): #只有根節點的情況直接刪除
		_delete_treeNode(node)
	else: #不是紅的也就是黑的
		if !sibling(node): #黑的沒有兄弟
			if node.P.color == RED: #爸爸是紅色的
				node.P.color = BLACK 
			else: #爸爸是黑色的
				node.P.color = BLACK
				#if sibling(node.P): #爸爸有兄弟
					#sibling(node.P).color = RED
			_delete_treeNode(node)
		elif sibling(node).color == BLACK: #兄弟是黑的
			if !child(sibling(node)): #且兄弟沒孩子
				if node.P.color == RED: #爸爸是紅的
					node.P.color = BLACK
				else: #爸爸是黑的
					node.P.color = BLACK
					if sibling(node.P): #爸爸有兄弟
						sibling(node.P).color = RED
				sibling(node).color = RED
			elif child(sibling(node)) == 3:
				if sibling(node).L.color == BLACK and sibling(node).R.color == BLACK:
					if node.P.color == RED: #爸爸是紅的
						node.P.color = BLACK
					else: #爸爸是黑的
						node.P.color = BLACK
						if sibling(node.P): #爸爸有兄弟
							sibling(node.P).color = RED
					sibling(node).color = RED
				else:
					if is_left_child(node):
						rotR(node.P.R.L)
						rotL(node.P.R)
					
			
				
		else:
			pass
		_delete_treeNode(node)
		

func _find_minR(node:TreeNode) -> TreeNode:
	while node.L != null:
		node = node.L
	return node
	
func _find_minL(node:TreeNode) -> TreeNode:
	while node.R != null:
		node = node.R
	return node
	
func laynR(node:TreeNode) -> int:
	var Rn:int = -1
	if node == null:
		return -2;
	while node.L != null:
		Rn += 1
		node = node.L
	if node.R:
		return Rn + 1
	return Rn

func laynL(node:TreeNode) -> int:
	var Ln:int = -1
	if node == null:
		return -2;
	while node.R != null:
		Ln += 1
		node = node.R
	if node.L:
		return Ln + 1
	return Ln

func rotL(P:TreeNode):
	MainScene.message("[color=yellow]L rotate ![/color]")
	var gp:TreeNode = P.PP
	var fa:TreeNode = P.P
	var y:TreeNode = P.L

	if y:
		y.P = fa
	fa.R = y
	
	P.L = fa
	fa.P = P

	if gp:
		if gp.L == fa:
			gp.L = P
		else:
			gp.R = P
	P.P = gp
	
	if _root == fa:
		_root = P

func rotR(P:TreeNode):
	MainScene.message("[color=yellow]R rotate ![/color]")
	var gp:TreeNode = P.PP
	var fa:TreeNode = P.P
	var y:TreeNode = P.R

	if y:
		y.P = fa
	fa.L = y
	
	P.R = fa
	fa.P = P

	if gp:
		if gp.L == fa:
			gp.L = P
		else:
			gp.R = P
	P.P = gp
	
	if _root == fa:
		_root = P
		
func sibling(node:TreeNode) -> TreeNode:
	if !node.P:
		return null
	if node == node.P.L:
		return node.P.R
	else:
		return node.P.L

func child(node:TreeNode) -> int:
	if node.L and node.R:
		return 3
	elif node.L:
		return 1
	elif node.R:
		return 2
	else:
		return 0
