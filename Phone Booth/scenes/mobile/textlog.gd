extends Control
var sender = null setget display_messages

var type = null
var types = {	"#CCFFCC":"left_msg", 
				"#99CCFF":"right_msg",
				"#FFCC99":"divider"}
var current_node = null

func display_messages(sender):
	if not sender == null: 
		$sender.text = sender
		clear_texts()
		if sender == "3042941":
			$numberClue.visible = true
		current_node = identify_next_node(Data.text_log_nodes[sender])
		add_entry(current_node)

func add_entry(nodeID): 
	if type == "divider": 
		$ScrollContainer/VBoxContainer.add_child($ResourcePreloader.get_resource("textDivider").instance())
	else: #must be a message
		var msg_node = $ResourcePreloader.get_resource("textMsg").instance()
		$ScrollContainer/VBoxContainer.add_child(msg_node)
		msg_node.is_left_message = true
		if type == "right_msg": 
			msg_node.is_left_message = false
		msg_node.message = Data.text_logs[nodeID]["#text"]
		
	var next_node = identify_next_node(nodeID)
	if next_node != null: 
		current_node = next_node
		add_entry(current_node)
	else: #scroll to the bottom 
		yield($ScrollContainer.get_v_scrollbar(),"changed")
		$ScrollContainer.scroll_vertical = $ScrollContainer.get_v_scrollbar().max_value

func clear_texts():
	if $ScrollContainer/VBoxContainer.get_child_count() > 0:
		for c in $ScrollContainer/VBoxContainer.get_children(): 
			c.queue_free()

func identify_next_node(nodeID):
	type = null
	var nID = null
	if Data.text_logs[nodeID].has("children"): 
		nID = Data.text_logs[nodeID]["children"][0]
		type = types[Data.text_logs[nID]["@color"]]
		return nID
