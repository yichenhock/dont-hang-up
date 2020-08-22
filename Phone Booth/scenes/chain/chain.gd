extends Node2D

# With help from: https://steemit.com/utopian-io/@sp33dy/tutorial-godot-engine-v3-gdscript-rigidbody-chain

const LOOP = preload("loop.tscn")
const LINK = preload("link.tscn")

export(int) var loops = 1

func _ready():
	var parent = $anchor
	for i in range(loops): 
		var child = addLoop(parent)
		addLink(parent,child)
		parent = child
	
func addLoop(parent): 
	var loop = LOOP.instance()
	loop.position = parent.position
	loop.position.y += 2
	add_child(loop)
	return loop
	
func addLink(parent,child): 
	var pin = LINK.instance()
	pin.node_a = parent.get_path()
	pin.node_b = child.get_path()
	parent.add_child(pin)


