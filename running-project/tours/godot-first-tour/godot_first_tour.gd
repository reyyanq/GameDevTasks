extends "res://addons/godot_tours/tour.gd"

const Gobot := preload("res://addons/godot_tours/bubble/gobot/gobot.gd")

const TEXTURE_BUBBLE_BACKGROUND := preload("res://addons/godot_tours/assets/images/bubble-background.png")
const TEXTURE_GDQUEST_LOGO := preload("res://addons/godot_tours/bubble/assets/icons/TitleBarLogo.svg")

const CREDITS_FOOTER_GDQUEST := "[center]Godot Interactive Tours · Made by [url=https://www.gdquest.com/][b]GDQuest[/b][/url] · [url=https://github.com/GDQuest][b]Github page[/b][/url][/center]"

const LEVEL_RECT := Rect2(Vector2.ZERO, Vector2(1920, 1080))
const LEVEL_CENTER_AT := Vector2(960, 540)

# Position we set to popup windows relative to the editor's top-left. This helps to keep the popup
# windows outside of the bubble's area.
const POPUP_WINDOW_POSITION := Vector2i(150, 150)
# We limit the size of popup windows
const POPUP_WINDOW_MAX_SIZE := Vector2i(860, 720)

const ICONS_MAP = {
	node_position_unselected = "res://assets/icon_editor_position_unselected.svg",
	node_position_selected = "res://assets/icon_editor_position_selected.svg",
	script_signal_connected = "res://assets/icon_script_signal_connected.svg",
	script = "res://assets/icon_script.svg",
	script_indent = "res://assets/icon_script_indent.svg",
	zoom_in = "res://assets/icon_zoom_in.svg",
	zoom_out = "res://assets/icon_zoom_out.svg",
	open_in_editor = "res://assets/icon_open_in_editor.svg",
	node_signal_connected = "res://assets/icon_signal_scene_dock.svg",
	instance = "res://addons/godot_tours/bubble/assets/icons/Instance.svg"
}


func _build() -> void:
	# Set editor state according to the tour's needs.
	queue_command(func reset_editor_state_for_tour():
		interface.canvas_item_editor_toolbar_grid_button.button_pressed = false
		interface.canvas_item_editor_toolbar_smart_snap_button.button_pressed = false
		interface.bottom_button_output.button_pressed = false
	)

	steps_010_intro()
	steps_020_editor_overview()
	steps_030_creating_first_scene()
	steps_040_nodes_and_scenes()
	steps_050_scripts()
	steps_060_signals()
	steps_070_running_scenes()
	steps_090_conclusion()


func steps_010_intro() -> void:

	# 0010: introduction
	context_set_2d()
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_background(TEXTURE_BUBBLE_BACKGROUND)
	bubble_add_texture(TEXTURE_GDQUEST_LOGO)
	bubble_set_title("")
	bubble_add_text([bbcode_wrap_font_size(gtr("[center][b]Welcome to Godot[/b][/center]"), 32)])
	bubble_add_text(
		[gtr("[center]In this tour, you take your first steps in the [b]Godot editor[/b].[/center]"),
		gtr("[center]You get an overview of the engine's four pillars: [b]Scenes[/b], [b]Nodes[/b], [b]Scripts[/b], and [b]Signals[/b].[/center]"),
		gtr("[center]We'll start with an empty project and build our understanding from the ground up.[/center]"),
		gtr("[center][b]Let's get started![/b][/center]"),]
	)
	bubble_set_footer(CREDITS_FOOTER_GDQUEST)
	queue_command(func avatar_wink(): bubble.avatar.do_wink())
	complete_step()


	# 0020: Editor tour introduction
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Editor tour"))
	bubble_add_text(
		[gtr("Let's take a tour of the Godot editor interface."),
		gtr("We'll explore each part of the editor and learn what it's used for."),]
	)
	queue_command(func():
		interface.bottom_button_output.button_pressed = false
	)
	complete_step()


func steps_020_editor_overview() -> void:
	# 0040: central viewport
	highlight_controls([interface.canvas_item_editor])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(gtr("The viewport"))
	bubble_add_text(
		[gtr("The central part of the editor outlined in purple is the viewport. It's a view of the currently open [b]scene[/b]."),
		gtr("Right now, we don't have any scene open, so the viewport appears empty."),]
	)
	complete_step()


	# 0041: looking around
	var controls_0041: Array[Control] = []
	controls_0041.assign([
		interface.scene_dock,
		interface.filesystem_dock,
		interface.inspector_dock,
		interface.context_switcher,
		interface.run_bar,
	] + interface.bottom_buttons)
	highlight_controls(controls_0041)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Let's look around"))
	bubble_add_text(
		[gtr("We're going to explore the interface next, so you get a good feel for it."),]
	)
	complete_step()


	# 0042: main screen buttons / "context switcher"
	highlight_controls([interface.context_switcher], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Context Switcher"))
	bubble_add_text([
		gtr("Centered at the top of the editor, you find the Godot [b]Context Switcher[/b]."),
		gtr("You can change between the different [b]Editor[/b] views here. We are currently on the [b]2D View[/b]. Later, we will switch to the [b]Script Editor[/b]!"),
	])
	complete_step()


	# 0042: playback controls/game preview buttons
	highlight_controls([interface.run_bar], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Runner Buttons"))
	bubble_add_text([gtr("Those buttons in the top-right are the Runner Buttons. You can [b]play[/b] and [b]stop[/b] games with them."),
		gtr("We'll use these later once we have a scene to run."),])
	complete_step()


	# 0042: scene dock
	context_set_2d()
	highlight_controls([interface.scene_dock])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(gtr("Scene Dock"))
	bubble_add_text([gtr("At the top-left, you have the [b]Scene Dock[/b]. You can see all the building blocks of a scene here."),
		gtr("In Godot, these building blocks are called [b]nodes[/b]."),
		gtr("A scene is made up of one or more nodes."),
		gtr("There are nodes to draw images, play sounds, design animations, and more."),
		gtr("Right now it's empty because we haven't created a scene yet."),
	])
	complete_step()


	# 0042: Filesystem dock
	highlight_controls([interface.filesystem_dock])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_title(gtr("FileSystem Dock"))
	bubble_add_text([gtr("At the bottom-left, you can see the [b]FileSystem Dock[/b]. It lists all the files used in your project (scenes, images, scripts, etc.)."),
		gtr("In an empty project, you'll only see basic project files."),])
	complete_step()


	# 0044: inspector dock
	highlight_controls([interface.inspector_dock])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("The Inspector"))
	bubble_add_text([
		gtr("On the right, we have the [b]Inspector Dock[/b]. In this dock, you can view and edit the properties of selected nodes."),
		gtr("It's empty now because we haven't selected any nodes yet."),
	])
	complete_step()


	# 0046: bottom panels
	queue_command(func debugger_open():
		interface.bottom_button_debugger.button_pressed = true
	)
	highlight_controls([interface.debugger])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("The Bottom Panels"))
	bubble_add_text([
		gtr("At the bottom, you'll find editors like the [b]Output[/b] and [b]Debugger[/b] panels."),
		gtr("That's where you'll edit animations, write visual effects code (shaders), and more."),
		gtr("These editors are contextual and will show content when you start working with them."),
		gtr(""),
		gtr("Now lets get a bit into scenes."),
	])
	complete_step()

	queue_command(func debugger_close():
		interface.bottom_button_debugger.button_pressed = false
	)


func steps_030_creating_first_scene() -> void:

	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("What is a scene?"))
	bubble_add_text([
		gtr("In Godot, a scene is a template that can represent anything: A character, a chest, an entire level, a menu, or even a complete game!"),
		gtr("Scenes are reusable and can be combined together to create complex games."),
		gtr("Let's create our first scene to see how this works."),
	])
	complete_step()

	# Create new scene using FileSystem
	highlight_controls([interface.filesystem_tree, interface.main_screen_tabs])
	bubble_move_and_anchor(interface.filesystem_dock, Bubble.At.TOP_RIGHT, 16.0, Vector2(550, 50))
	bubble_set_title(gtr("Create a new scene"))
	bubble_add_text([
		gtr("Let's create a new scene to experiment with."),
		gtr("Right-click in the FileSystem dock and select '[b]Create New → Scene[/b]'."),
		gtr("Alternatively, you can click the '+' button in the scene tab bar, but this method requires manual saving of the scene."),
		gtr(""),
		gtr("In the pop-up, select '2D Scene' as the root node and name it 'my_first_scene'."),
	])
	bubble_add_task(
		gtr("Create a new scene called 'my_first_scene'"), 
		1,
		func(task: Task) -> int:
			return 1 if FileAccess.file_exists("res://my_first_scene.tscn") else 0
	)
	complete_step()

	# Scene is now open and ready
	highlight_controls([interface.scene_dock])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title(gtr("Your scene is ready"))
	bubble_add_text([
		gtr("Great! Your scene has been created and opened automatically."),
		gtr("You should see a [b]Node2D[/b] named [b]MyFirstScene[/b] in the Scene Dock: This is your root node."),
	])
	complete_step()

	# Add child nodes to the existing scene
	highlight_controls([interface.node_create_dialog_search_bar, interface.node_create_dialog_button_create, interface.node_create_dialog_node_tree])
	highlight_scene_nodes_by_name(["MyFirstScene"])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title(gtr("Add child nodes"))
	bubble_add_text([
		gtr("Now let's add some child nodes to see how the hierarchy works."),
		gtr("Right-click on the Node2D and select 'Add Child', or click the [b]+[/b] button."),
		gtr("Try adding a [b]Sprite2D[/b] node as a child."),
	])
	bubble_add_task(
		gtr("Add a [b]Sprite2D[/b] as a child of Node2D"),
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var sprite_node = scene_root.find_child("Sprite2D")
				return 1 if sprite_node != null else 0
			return 0
	)
	complete_step()

	# Explain the scene structure
	highlight_controls([interface.scene_dock])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title(gtr("Understanding scene structure"))
	bubble_add_text([
		gtr("Look at the Scene Dock. You can see the hierarchy of nodes."),
		gtr("The [b]Node2D[/b] is the root (parent), and [b]Sprite2D[/b] is its child."),
		gtr("You can add more children, and children can have their own children."),
		gtr("This tree structure is how you organize all the parts of your game."),
	])
	complete_step()


func steps_040_nodes_and_scenes() -> void:

	# Show different node types
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Common node types"))
	bubble_add_text([
		gtr("Here are some common node types you'll use:"),
		gtr(""),
		gtr("[b]Node2D[/b] - Basic 2D node for positioning and organizing"),
		gtr("[b]Sprite2D[/b] - Displays 2D images"),
		gtr("[b]CharacterBody2D[/b] - For characters that move and collide"),
		gtr("[b]Area2D[/b] - Detects when things enter an area"),
		gtr("[b]Timer[/b] - Counts down time and sends signals"),
		gtr("[b]Label[/b] - Displays text on screen"),
	])
	complete_step()

	# Scene instances
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Scene instances"))
	bubble_add_text([
		gtr("You can use scenes inside other scenes. These are called 'scene instances'."),
		gtr("For example, you might create a 'Player' scene, then instance it inside a 'Level' scene."),
		gtr("This lets you reuse content and keep your project organized."),
		gtr("Scene instances appear with a %s special icon in the Scene Dock.")  % bbcode_generate_icon_image_string(ICONS_MAP.instance),
	])
	complete_step()


func steps_050_scripts() -> void:

	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Scripts bring nodes to life"))
	bubble_add_text([
		gtr("By themselves, nodes are just static objects."),
		gtr("To make them interactive and give them behavior, you need to write [b]scripts[/b]."),
		gtr("Scripts are text files containing code that tells nodes what to do and when to do it."),
	])
	complete_step()

	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Attaching scripts"))
	bubble_add_text([
		gtr("You can attach a script to any node by right-clicking on it in the [b]Scene Dock[/b] and selecting [b]Attach Script[/b]."),
		gtr("Once attached, the node will have a script icon next to its name."),
		gtr("Let's try attaching a script to one of our nodes."),
	])
	complete_step()

	# Practical script attachment
	highlight_scene_nodes_by_name(["Node2D"])
	highlight_controls([interface.scene_dock.get_children()[0].get_children()[3]])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title(gtr("Attach a script"))
	bubble_add_text([
		gtr("Right-click on the [b]Node2D[/b] node in the Scene Dock and select '[b]Attach Script[/b]'."),
		gtr("In the dialog that appears, you can choose the script language and path."),
		gtr("For now, just click 'Create' to create a basic script."),
	])
	bubble_add_task(
		gtr("Attach a script to the Node2D node"),
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				return 1 if scene_root.get_script() != null else 0
			return 0
	)
	complete_step()

	highlight_controls([interface.context_switcher], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("The Script Editor"))
	bubble_add_text([
		gtr("When you create a script, Godot automatically switches to the [b]Script[/b] context."),
		gtr("This is where you can write and edit code for your nodes."),
		gtr("You can always switch back to the 2D view by clicking the [b]2D[/b] tab."),
	])
	complete_step()

	# Show basic script structure
	context_set_script()
	highlight_controls([interface.script_editor_code_panel])
	bubble_move_and_anchor(interface.script_editor_code_panel, Bubble.At.TOP_RIGHT)
	bubble_set_title(gtr("Understanding the script"))
	bubble_add_text([
		gtr("You should see some basic code that was generated automatically."),
		gtr("The line [code]extends Node2D[/code] tells Godot this script controls a Node2D."),
		gtr("You can add functions here to make your node do things."),
		gtr("Don't worry if you can't code yet, Godot uses a Python-like language called GDScript that's easy to learn!"),
	])
	complete_step()


func steps_060_signals() -> void:

	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("What are signals?"))
	bubble_add_text([
		gtr("Signals are Godot's way of letting nodes communicate with each other."),
		gtr("When something interesting happens to a node (like a button being clicked, or a character taking damage), the node can emit a signal."),
		gtr("Other nodes can 'listen' for these signals and react accordingly."),
	])
	complete_step()

	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Signal connections"))
	bubble_add_text([
		gtr("To use signals, you connect them to functions in scripts."),
		gtr("For example: when a button emits a 'pressed' signal, you might connect it to a function that opens a menu."),
		gtr("This system makes it easy to create responsive, interactive games without complex code relationships."),
	])
	complete_step()

	# Switch back to 2D context to show Node dock
	context_set_2d()
	highlight_scene_nodes_by_name(["Node2D"])
	highlight_controls([interface.node_dock_signals_button, interface.node_dock_signals_editor, interface.signals_dialog, interface.signals_dialog_ok_button, interface.inspector_tabs])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("The Node Dock"))
	bubble_add_text([
		gtr("The [b]Node Dock[/b] on the right side of the screen shows you all available signals for the selected node."),
		gtr("Select the Node2D in the Scene Dock, then click on the 'Node' tab next to the Inspector."),
		gtr("You can see which signals are available and create new connections here."),
		gtr("If there are no signals visible, you need to first select a node in the scene tree."),
	])
	bubble_add_task_set_tab_by_control(interface.node_dock, gtr("Open the Node Dock to see available signals"))
	complete_step()

	# Show signals in the Node dock
	highlight_controls([interface.node_dock_signals_editor])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Available signals"))
	bubble_add_text([
		gtr("In the Node Dock, you can see all the signals that the selected node can emit."),
		gtr("Different node types have different signals, for example, Button nodes have 'pressed' signals, while Area2D nodes have collision signals."),
		gtr("When you need nodes to communicate, you'll come back here to set up connections."),
	])
	complete_step()


func steps_070_running_scenes() -> void:

	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(gtr("Running your scene"))
	bubble_add_text([
		gtr("Now that you've created a scene with nodes and a script, let's see how to run it."),
		gtr("Running scenes is how you test your game as you develop it."),
	])
	complete_step()

	# Save first
	highlight_controls([interface.canvas_item_editor])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_title(gtr("Save your scene first"))
	bubble_add_text([
		gtr("Before running a scene, make sure it's saved."),
		gtr("If you haven't saved it yet, press [b]Ctrl+S[/b] to save it now."),
	])
	complete_step()

	# Run current scene
	highlight_controls([interface.run_bar_play_button], true)
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(gtr("Run the current scene"))
	bubble_add_text([
		gtr("Click the play button in the top-right to run your current scene."),
		gtr("This will open a window showing your main scene in action."),
		gtr("If there is no main scene declared yet, Godot will ask you to to that in a pop up."),
		gtr("Since our scene is simple, you might just see an empty window!"),
	])
	bubble_add_task_press_button(interface.run_bar_play_button)
	complete_step()


func steps_090_conclusion() -> void:
	bubble_move_and_anchor(interface.main_screen)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	queue_command(func set_avatar_happy() -> void:
		bubble.avatar.set_expression(Gobot.Expressions.HAPPY)
	)
	bubble_set_background(TEXTURE_BUBBLE_BACKGROUND)
	bubble_add_texture(TEXTURE_GDQUEST_LOGO)
	bubble_set_title("")
	bubble_add_text([bbcode_wrap_font_size(gtr("[center][b]Congratulations on your first Godot Tour![/b][/center]"), 32)])
	bubble_add_text([
		gtr("[center]You've learned the fundamentals of the Godot editor. Ready to keep learning?[/center]"),
	])
	bubble_add_text([
		gtr("Now that you understand the basics, you're ready to start creating!"),
		gtr("Try creating some nodes, experimenting with the inspector, and maybe even writing your first script."),
		gtr("After experimenting a bit you can start with your first assignment."),
	])
	bubble_set_footer((CREDITS_FOOTER_GDQUEST))
	complete_step()
