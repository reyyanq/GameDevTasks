# godot_gallery_shooter_tour.gd
extends "res://addons/godot_tours/tour.gd"

const BUBBLE_BACKGROUND := preload("res://addons/godot_tours/assets/images/bubble-background.png")
const SPACE_BACKGROUND := preload("res://gallery_shooter/assets/background/bg-preview-big.png")
const CREDITS_FOOTER := "[center]Gallery Shooter Tutorial · Learn Game Development in Godot[/center]"

# Scene and asset paths - updated for gallery_shooter folder
var main_scene := "res://gallery_shooter/scenes/zone.tscn"
var target_scene := "res://gallery_shooter/scenes/target.tscn"
var zone_script := "res://gallery_shooter/scripts/zone.gd"
var target_script := "res://gallery_shooter/scripts/target.gd"

const ICONS_MAP = {
	node_position_unselected = "res://assets/icon_editor_position_unselected.svg",
	node_position_selected = "res://assets/icon_editor_position_selected.svg",
	script_signal_connected = "res://addons/godot_tours/bubble/assets/icons/Signals.svg",
	script = "res://addons/godot_tours/bubble/assets/icons/ScriptCreate.svg",
	timer = "res://addons/godot_tours/bubble/assets/icons/Timer.svg",
	target = "res://tours/gallery-shooter/assets/asteroid.png",
	crosshair = "res://tours/gallery-shooter/assets/crosshair.png",
	zone = "res://tours/gallery-shooter/assets/background/bg-preview-big.png",
	animation = "res://addons/godot_tours/bubble/assets/icons/AnimationPlayer.svg",
	group = "res://addons/godot_tours/bubble/assets/icons/Group.svg",
	loop = "res://addons/godot_tours/bubble/assets/icons/Loop.svg",
	autoplay = "res://addons/godot_tours/bubble/assets/icons/AutoPlay.svg",
	time = "res://addons/godot_tours/bubble/assets/icons/Time.svg",
	keyframe = "res://addons/godot_tours/bubble/assets/icons/KeyBezierPoint.svg",
	key = "res://addons/godot_tours/bubble/assets/icons/Key.svg",
	cubic = "res://addons/godot_tours/bubble/assets/icons/InterpCubic.svg"
}

func _build() -> void:
	# Disable overlays for better interaction
	queue_command(overlays.toggle_dimmers, [false])
	
	# Set up initial editor state
	queue_command(func setup_editor():
		interface.canvas_item_editor_toolbar_grid_button.button_pressed = false
		interface.canvas_item_editor_toolbar_smart_snap_button.button_pressed = false
		interface.bottom_button_output.button_pressed = false
	)

	# Tour sections
	#section_01_introduction()
	#section_02_project_setup()
	#section_03_main_game_scene()
	#section_04_target_creation()
	#section_05_target_animations()
	#section_06_spawning_system()
	#section_07_input_system()
	section_08_polishing()
	section_09_conclusion()

func bbcode_generate_large_icon(image_filepath: String, width: int = 48, height: int = 48) -> String:
	return "[img=%sx%s]%s[/img]" % [width, height, image_filepath]

func section_01_introduction() -> void:
	# Welcome screen - combined introduction
	context_set_2d()
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	if SPACE_BACKGROUND:
		bubble_set_background(SPACE_BACKGROUND)
	bubble_set_title("")
	bubble_add_text([bbcode_wrap_font_size("[center][b]Create Your First Gallery Shooter in Godot[/b][/center]", 28), ""])
	#if FileAccess.file_exists("res://assets/GalleryShooter.png"):
		#bubble_add_texture(preload("res://assets/GalleryShooter.png"), 300.0)
	bubble_add_text([
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"[center]In this tutorial, you'll learn to create a gallery shooter game where players shoot moving targets within a time limit.[/center]",
		"[center]By the end of this tutorial, you'll have a working game with spawning targets, timer system, and scoring mechanics.[/center]",
		""
	])
	bubble_set_footer(CREDITS_FOOTER)
	complete_step()
	
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Gallery Shooter Overview")
	bubble_add_text([
		"Our gallery shooter consists of these core elements:",
		"",
		"[b]%s   Moving Targets[/b]" % bbcode_generate_large_icon(ICONS_MAP.target, 48, 48),
		"Targets that appear from screen edges and move across the screen with different patterns and speeds.",
		"",
		"[b]%s   Timer System[/b]" % bbcode_generate_large_icon(ICONS_MAP.timer, 48, 48),
		"A countdown timer that controls game duration, with UI elements showing remaining time.",
		"",
		"[b]%s Spawning Zone[/b]" % bbcode_generate_large_icon(ICONS_MAP.zone, 48, 48),
		"A system that handles the creation and positioning of targets at regular intervals.",
	])
	complete_step()
	
	# Tutorial structure
	bubble_set_title("Tutorial Structure")
	bubble_add_text([
		"We'll build the gallery shooter step by step:",
		"",
		"[b]1. Project Setup[/b] - Organize files and configure input",
		"[b]2. Main Game Scene[/b] - Create the zone with timers and UI",
		"[b]3. Target Creation[/b] - Build shootable targets with collision",
		"[b]4. Animation System[/b] - Add movement patterns for targets",
		"[b]5. Spawning System[/b] - Create the target generation logic",
		"[b]6. Input System[/b] - Handle mouse clicks and shooting",
		"[b]7. Polish & Effects[/b] - Add cursor changes and refinements",
		"",
		"[center]Let's start building your gallery shooter![/center]"
	])
	complete_step()

func section_02_project_setup() -> void:
	# Project creation step
	bubble_set_title("Project Organization")
	bubble_add_text([
		"Before we start coding, we need to organize our project files for the gallery shooter.",
		"",
		"We'll create folders to separate different types of files as well as a different folder for the game we create to keep it seperate from other tour projects."
	])
	complete_step()

	# Create gallery shooter folders
	bubble_set_title("Create Project Folders")
	highlight_controls([interface.filesystem_dock])
	bubble_move_and_anchor(interface.filesystem_dock, Bubble.At.TOP_RIGHT, 16.0, Vector2(550, 0))
	bubble_add_text([
		"We'll create a folder structure for our gallery shooter:",
		"",
		"[code]res://gallery_shooter/[/code]",
		"[code]├── assets/     # Images, sounds, and media[/code]",
		"[code]├── scenes/     # Game scenes (.tscn files)[/code]",
		"[code]└── scripts/    # Code files (.gd files)[/code]",
	])
	complete_step()

	# Create main gallery shooter folder
	highlight_controls([interface.filesystem_dock])
	bubble_add_text([
		"First, create the main 'gallery_shooter' folder."
	])
	bubble_add_task(
		"Create the 'gallery_shooter' folder",
		1,
		func(task: Task) -> int:
			return 1 if DirAccess.dir_exists_absolute("res://gallery_shooter") else 0
	)
	complete_step()

	# Create subfolders task
	highlight_controls([interface.filesystem_dock])
	bubble_add_text([
		"Now create three subfolders inside 'gallery_shooter':",
		"",
		"• [b]assets[/b] - For images, sounds, and other media files",
		"• [b]scenes[/b] - For .tscn scene files (zones, targets, UI)",
		"• [b]scripts[/b] - For .gd script files (game logic and behavior)",
		"",
		"Right-click on the 'gallery_shooter' folder to create each one inside the projects folder."
	])
	bubble_add_task(
		"Create 'assets', 'scenes', and 'scripts' folders inside 'gallery_shooter'",
		1,
		func(task: Task) -> int:
			return 1 if (
				DirAccess.dir_exists_absolute("res://gallery_shooter/assets") and
				DirAccess.dir_exists_absolute("res://gallery_shooter/scenes") and
				DirAccess.dir_exists_absolute("res://gallery_shooter/scripts")
			) else 0
	)
	complete_step()

func section_03_main_game_scene() -> void:
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Creating the Main Game Scene")
	bubble_add_text([
		"Let's start by setting up the main scene that will control our game flow.",
		"",
		"This scene will be called 'Zone' and will contain:",
		"• Timer systems for game duration and target spawning",
		"• UI elements to display time remaining",
		"• The main game logic for managing targets"
	])
	complete_step()

	# Create zone scene
	highlight_controls([interface.filesystem_tree, interface.main_screen_tabs])
	highlight_filesystem_paths(["gallery_shooter", "gallery_shooter/scenes"])
	bubble_move_and_anchor(interface.filesystem_dock, Bubble.At.TOP_RIGHT, 16.0, Vector2(550, 50))
	bubble_set_title("Create the Zone Scene")
	bubble_add_text([
		"Let's create our main game scene.",
		"",
		"Right-click on the 'scenes' folder and select '[b]Create New → Scene[/b]'.",
		"In the dialog, choose 'Node2D' and name it 'zone'.",
	])
	bubble_add_task(
		"Create a new scene called 'zone' in the scenes folder",
		1,
		func(task: Task) -> int:
			return 1 if FileAccess.file_exists("res://gallery_shooter/scenes/zone.tscn") else 0
	)
	complete_step()

	# Open the zone scene and set up structure
	scene_open("res://gallery_shooter/scenes/zone.tscn")
	highlight_controls([interface.scene_dock])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title("Set Up Zone Structure")
	bubble_add_text([
		"Now we'll add the nodes needed for our gallery shooter.",
		"",
		"Our scene structure will be:",
		"",
		"[code]Zone (Node2D)[/code]",
		"[code]├── WorldTimer (Timer)[/code]",
		"[code]├── DelayTimer (Timer)[/code]",
		"[code]└── CanvasLayer[/code]",
		"[code]    └── Label (time display)[/code]"
	])
	complete_step()

	# Add WorldTimer
	highlight_scene_nodes_by_name(["Zone"])
	highlight_controls([interface.scene_dock_button_add])
	bubble_set_title("Add WorldTimer")
	bubble_add_text([
		"Add a [b]Timer[/b] node as a child of Zone and name it 'WorldTimer'.",
		"",
		"This timer will control the overall game duration (20 seconds)."
	])
	bubble_add_task(
		"Add Timer node and rename it to 'WorldTimer'",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root and scene_root.name == "Zone":
				return 1 if scene_root.find_child("WorldTimer") != null else 0
			return 0
	)
	complete_step()

	# Configure WorldTimer
	highlight_scene_nodes_by_name(["WorldTimer"])
	highlight_controls([interface.inspector_dock])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Configure WorldTimer")
	bubble_add_text([
		"Select the WorldTimer and configure it in the Inspector:",
		"",
		"• Enable '[b]One Shot[/b]' - so it only runs once",
		"• Enable '[b]Autostart[/b]' - so it runs on start up",
		"• Set '[b]Wait Time[/b]' to 20 seconds",
		"",
		"This timer controls the overall game duration."
	])
	complete_step()

	# Add DelayTimer
	highlight_scene_nodes_by_name(["Zone"])
	highlight_controls([interface.scene_dock_button_add])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title("Add DelayTimer")
	bubble_add_text([
		"Add another [b]Timer[/b] node as a child of Zone and name it 'DelayTimer'.",
		"",
		"This timer will control how often new targets spawn."
	])
	bubble_add_task(
		"Add Timer node and rename it to 'DelayTimer'",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root and scene_root.name == "Zone":
				return 1 if scene_root.find_child("DelayTimer") != null else 0
			return 0
	)
	complete_step()

	# Configure DelayTimer
	highlight_scene_nodes_by_name(["DelayTimer"])
	highlight_controls([interface.inspector_dock])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Configure DelayTimer")
	bubble_add_text([
		"Select the DelayTimer and configure it:",
		"",
		"• Set '[b]Wait Time[/b]' to 1.5 seconds",
		"",
		"This timer will repeat every 1.5 seconds to spawn new targets."
	])
	complete_step()

	# Add UI elements
	highlight_scene_nodes_by_name(["Zone"])
	highlight_controls([interface.scene_dock_button_add])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title("Add UI Elements")
	bubble_add_text([
		"Now add UI elements to display the remaining time:",
		"",
		"1. Add a [b]CanvasLayer[/b] node as a child of Zone",
		"2. Add a [b]Label[/b] node as a child of CanvasLayer",
	])
	bubble_add_task(
		"Add CanvasLayer and Label nodes for UI",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root and scene_root.name == "Zone":
				var canvas_layer = scene_root.find_child("CanvasLayer")
				if canvas_layer != null:
					var label = canvas_layer.find_child("Label")
					return 1 if label != null else 0
			return 0
	)
	complete_step()

	# Configure the Label
	highlight_scene_nodes_by_name(["Label"])
	highlight_controls([interface.inspector_dock])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Configure Time Display")
	bubble_add_text([
		"Select the Label and configure it for displaying time:",
		"",
		"1. Set the '[b]Text[/b]' property to '20' (starting time)",
		"2. Position it in the top-center of the screen",
		"3. Increase the font size in '[b]Theme Overrides → Font Sizes → Font Size[/b]' to make it more visible",
		"4. Consider centering the text alignment",
		"",
		"This will show the countdown timer to players."
	])
	complete_step()

	# Add Zone script
	highlight_scene_nodes_by_name(["Zone"])
	highlight_controls([interface.scene_dock.get_children()[0].get_children()[3]])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title("Add Zone Script")
	bubble_add_text([
		"Now we need to add a script to control our zone logic.",
		"",
		"Press the attach script button %s or right-click on the [b]Zone[/b] node and select '[b]Attach Script[/b]'." % bbcode_generate_icon_image_string(ICONS_MAP.script),
		"Save the script as 'zone.gd' in the scripts folder."
	])
	bubble_add_task(
		"Attach a script to the Zone node and save it as 'zone.gd'",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root and scene_root.name == "Zone":
				return 1 if scene_root.get_script() != null else 0
			return 0
	)
	complete_step()

	# Show initial zone code
	context_set_script()
	queue_command(func():
		var script_path = "res://gallery_shooter/scripts/zone.gd"
		if FileAccess.file_exists(script_path):
			var script_resource = load(script_path)
			EditorInterface.edit_resource(script_resource)
	)
	highlight_controls([interface.script_editor_code_panel])
	bubble_move_and_anchor(interface.script_editor_code_panel, Bubble.At.TOP_RIGHT)
	bubble_set_title("Initial Zone Script")
	bubble_add_text([
		"Replace the default script with this basic zone code:",
		""
	])
	bubble_add_code([
"extends Node2D

func _ready():
	randomize()  # Initialize random number generator
	$WorldTimer.start(20)  # Start with 20 seconds

func _process(_delta):
	# Update time display
	$CanvasLayer/Label.text = str(int($WorldTimer.time_left))"
	])
	bubble_add_text([
		"",
		"This code:",
		"• Starts the world timer when the game begins",
		"• Updates the label to show remaining time every frame",
		"• Uses randomize() to ensure random target spawning later"
	])
	complete_step()

	# Save and test
	bubble_set_title("Test the Timer System")
	bubble_add_text([
		"Save your script with [b]Ctrl+S[/b] and test the timer.",
		"",
		"When you run the scene, you should see:",
		"• A countdown from 20 to 0",
		"• The timer stops at 0",
	])
	bubble_add_task(
		"Save the zone script and test that the timer counts down",
		1,
		func(task: Task) -> int:
			var script_path = "res://gallery_shooter/scripts/zone.gd"
			if FileAccess.file_exists(script_path):
				var file_content = FileAccess.get_file_as_string(script_path)
				var has_extends = file_content.contains("extends Node2D")
				var has_ready = file_content.contains("_ready")
				var has_timer_start = file_content.contains("WorldTimer.start")
				var has_process = file_content.contains("_process")
				var has_label_update = file_content.contains("CanvasLayer/Label.text")
				
				return 1 if has_extends and has_ready and has_timer_start and has_process and has_label_update else 0
			return 0
	)
	complete_step()

func section_04_target_creation() -> void:
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Creating the Target")
	if FileAccess.file_exists("res://tours/gallery-shooter/assets/asteroid_big.png"):
		bubble_add_texture(preload("res://tours/gallery-shooter/assets/asteroid_big.png"), 300.0)
	bubble_add_text([
		"Now let's create the targets that players will shoot at.",
		"",
		"Our targets will:",
		"• Detect mouse hover and clicks",
		"• Send signals when shot",
		"• Move across the screen with animations",
		"• Add time to the game when hit"
	])
	complete_step()

	# Create target scene
	highlight_controls([interface.filesystem_tree, interface.main_screen_tabs])
	highlight_filesystem_paths(["gallery_shooter", "gallery_shooter/scenes"])
	bubble_move_and_anchor(interface.filesystem_dock, Bubble.At.TOP_RIGHT, 16.0, Vector2(550, 50))
	bubble_set_title("Create Target Scene")
	bubble_add_text([
		"Let's create a new scene for our targets.",
		"",
		"Right-click on the 'scenes' folder and select '[b]Create New → Scene[/b]'.",
		"In the dialog, choose 'Area2D' and name it 'target'.",
		"",
		"We use an Area2D to detect mouse interactions."
	])
	bubble_add_task(
		"Create a new scene called 'target' in the scenes folder",
		1,
		func(task: Task) -> int:
			return 1 if FileAccess.file_exists("res://gallery_shooter/scenes/target.tscn") else 0
	)
	complete_step()

	# Set up target structure
	scene_open("res://gallery_shooter/scenes/target.tscn")
	highlight_controls([interface.scene_dock, interface.scene_dock_button_add])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title("Target Scene Setup")
	bubble_add_text([
		"Add these child nodes to your Target (Area2D):",
		"",
		"[code]Target (Area2D)[/code]",
		"[code]├── Sprite2D[/code]",
		"[code]├── CollisionShape2D[/code]",
		"[code]└── AnimationPlayer[/code]",
	])
	bubble_add_task(
		"Add Sprite2D, CollisionShape2D, and AnimationPlayer as children of Target",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var correct_scene = scene_root.name == "Target" or scene_root.name == "Area2D"
				if correct_scene:
					var has_sprite = scene_root.find_child("Sprite2D") != null
					var has_collision = scene_root.find_child("CollisionShape2D") != null
					var has_animation = scene_root.find_child("AnimationPlayer") != null
					return 1 if has_sprite and has_collision and has_animation else 0
			return 0
	)
	complete_step()

	# Configure Sprite2D
	context_set_2d()
	highlight_scene_nodes_by_name(["Sprite2D"])
	highlight_controls([interface.inspector_dock])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Add Target Sprite")
	bubble_add_text([
		"Select the [b]Sprite2D[/b] node and give it a texture.",
		"",
		"In the Inspector, find the '[b]Texture[/b]' property and load your target image.",
		"",
		"Choose an image that represents what players will shoot at."
	])
	bubble_add_task(
		"Add a texture to the Sprite2D node",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var sprite = scene_root.find_child("Sprite2D")
				if sprite != null:
					var texture = sprite.get("texture")
					return 1 if texture != null else 0
			return 0
	)
	complete_step()

	# Configure CollisionShape2D
	highlight_scene_nodes_by_name(["CollisionShape2D"])
	highlight_controls([interface.inspector_dock, interface.canvas_item_editor])
	bubble_set_title("Configure Collision Shape")
	bubble_add_text([
		"Select the [b]CollisionShape2D[/b] node and set up its shape.",
		"",
		"In the Inspector, find the '[b]Shape[/b]' property and create a '[b]New RectangleShape2D[/b]' or '[b]New CircleShape2D[/b]'.",
		"",
		"Size it to match your target sprite as this defines the clickable area."
	])
	bubble_add_task(
		"Configure the CollisionShape2D with a shape",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var collision_shape = scene_root.find_child("CollisionShape2D")
				if collision_shape != null:
					var shape = collision_shape.get("shape")
					return 1 if shape != null else 0
			return 0
	)
	complete_step()

	# Add target script
	highlight_scene_nodes_by_name(["Target"])
	highlight_controls([interface.scene_dock.get_children()[0].get_children()[3]])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title("Add Target Script")
	bubble_add_text([
		"Now add a script to handle target behavior.",
		"",
		"Press the attach script button %s or right-click on the [b]Target[/b] node and select '[b]Attach Script[/b]'." % bbcode_generate_icon_image_string(ICONS_MAP.script),
		"Save the script as 'target.gd' in the scripts folder."
	])
	bubble_add_task(
		"Attach a script to the Target node and save it as 'target.gd'",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root and scene_root.name == "Target":
				return 1 if scene_root.get_script() != null else 0
			return 0
	)
	complete_step()

	# Show target script
	context_set_script()
	queue_command(func():
		var script_path = "res://gallery_shooter/scripts/target.gd"
		if FileAccess.file_exists(script_path):
			var script_resource = load(script_path)
			EditorInterface.edit_resource(script_resource)
	)
	highlight_controls([interface.script_editor_code_panel])
	bubble_move_and_anchor(interface.script_editor_code_panel, Bubble.At.TOP_RIGHT)
	bubble_set_title("Basic Target Script")
	bubble_add_text([
		"Replace the default script with this target code:",
		"",
	])
	bubble_add_code([
"extends Area2D

signal time_added

var hovering: bool = false
var difficulty: int = 1

func _on_mouse_entered():
	hovering = true

func _on_mouse_exited():
	hovering = false

func _unhandled_input(event):
	if event.is_action_pressed('ui_accept') && hovering:
		time_added.emit(difficulty)
		queue_free()"
	])
	complete_step()

	# Explain the target script
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Understanding Target Code")
	bubble_add_text([
		"Let's break down the key parts:",
		"",
		"[b]signal time_added[/b] - Creates a signal",
		"[b]time_added.emit(difficulty)[/b] - Emits the signal with arguments",
		"[b]var hovering[/b] - Tracks if the mouse is over the target",
		"[b]var difficulty[/b] - Point value when the target is hit",
		"[b]_on_mouse_entered/exited[/b] - Detects mouse hover",
		"[b]_unhandled_input[/b] - Handles click detection",
		"[b]queue_free()[/b] - Safely removes the target when shot"
	])
	complete_step()

	# Connect signals
	context_set_2d()
	highlight_scene_nodes_by_name(["Target"])
	highlight_controls([interface.node_dock_signals_button, interface.node_dock_signals_editor, interface.signals_dialog, interface.signals_dialog_ok_button, interface.inspector_tabs])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Connect Mouse Signals")
	bubble_add_text([
		"We need to connect the Area2D's mouse signals to our script functions.",
		"",
		"Select the Target node, then in the Inspector:",
		"1. Click on the 'Node' tab (next to Inspector)",
		"2. Find 'mouse_entered' signal and double-click it",
		"3. Connect it to '_on_mouse_entered' method - it should be chosen by default",
		"4. Do the same for 'mouse_exited' → '_on_mouse_exited'",
		"",
		"This enables hover detection for our targets."
	])
	complete_step()

func section_05_target_animations() -> void:
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Target Animations")
	bubble_add_text([
		"Now we'll create movement patterns for our targets using the [b]AnimationPlayer[/b].",
		"",
		"We'll create different animations:",
		"• Straight movement (horizontal and vertical)",
		"• A Wave pattern for more challenging targets",
	])
	complete_step()

	# Open target scene and focus on AnimationPlayer
	var animation_editor = interface.logger.get_parent().get_parent().get_children()[0].get_children()[2]
	var animation_editor_button = interface.bottom_buttons_container.get_children()[4]
	scene_open("res://gallery_shooter/scenes/target.tscn")
	highlight_scene_nodes_by_name(["AnimationPlayer"])
	highlight_controls([interface.animation_player, animation_editor, animation_editor_button])
	bubble_move_and_anchor(interface.animation_player, Bubble.At.TOP_CENTER, 16, Vector2(0, -600))
	bubble_set_title("Animation Player Setup")
	bubble_add_text([
		"Select the [b]AnimationPlayer[/b] node in your target scene.",
		"",
		"The Animation panel should appear at the bottom of the screen.",
		"",
		"We'll use this to create keyframe animations that move our targets across the screen."
	])
	complete_step()

	# Create first animation
	highlight_controls([interface.animation_player])
	bubble_move_and_anchor(interface.animation_player, Bubble.At.TOP_CENTER, 16, Vector2(0, -600))
	bubble_set_title("Create Straight Right Animation")
	bubble_add_text([
		"Let's create our first animation: A target moving from left to right.",
		"",
		"1. In the Animation panel, click [b]'Animation' → 'New...'[/b]",
		"2. Name it 'straight_right'",
		"3. Set the length to 1 second %s"  % bbcode_generate_icon_image_string(ICONS_MAP.time),
	])
	complete_step()

	# Explain keyframes
	highlight_controls([interface.animation_player])
	bubble_move_and_anchor(interface.animation_player, Bubble.At.TOP_CENTER, 16, Vector2(0, -600))
	bubble_set_title("Understanding Keyframes")
	bubble_add_text([
		" %s [b]Keyframes[/b] define specific values at specific times in the animation."  % bbcode_generate_icon_image_string(ICONS_MAP.keyframe),
		"",
		"For position animation:",
		"• At 0.0 seconds: Target starts at one position",
		"• At 1.0 seconds: Target ends at another position",
		"• Godot smoothly moves between these points",
		"",
		"We'll set %s [b]Keyframes[/b] for the Target's position property."  % bbcode_generate_icon_image_string(ICONS_MAP.keyframe)
	])
	complete_step()

	# Create position keyframes
	highlight_scene_nodes_by_name(["Target"])
	bubble_move_and_anchor(interface.animation_player, Bubble.At.TOP_CENTER, 16, Vector2(0, -600))
	highlight_controls([interface.animation_player, interface.inspector_dock])
	bubble_set_title("Create Position Keyframes")
	bubble_add_text([
		"Now let's create the %s [b]Keyframes[/b] for straight_right movement:" % bbcode_generate_icon_image_string(ICONS_MAP.keyframe),
		"",
		"1. Make sure the timeline is at 0:00",
		"2. Select the [b]Target[/b] node",
		"3. In the Inspector, find the '[b]Position[/b]' property",
		"4. Set position to Vector2(0, 0)",
		"5. Click the %s [b]key[/b] button next to Position to create a keyframe" % bbcode_generate_icon_image_string(ICONS_MAP.key),
		"",
		"This sets the starting position."
	])
	complete_step()

	highlight_scene_nodes_by_name(["Target"])
	highlight_controls([interface.animation_player, interface.inspector_dock])
	bubble_move_and_anchor(interface.animation_player, Bubble.At.TOP_CENTER, 16, Vector2(0, -600))
	bubble_set_title("Create End Position")
	bubble_add_text([
		"Now for the end position:",
		"",
		"1. Move the timeline to 1:00 (1 second)",
		"2. Change the Target's position to Vector2(1200, 0)",
		"3. Click the %s [b]key[/b] button again" % bbcode_generate_icon_image_string(ICONS_MAP.key),
		"",
		"The target will now move 1200 pixels to the right over 1 second."
	])
	complete_step()

	# Test the animation
	highlight_controls([interface.animation_player, interface.canvas_item_editor])
	bubble_move_and_anchor(interface.canvas_item_editor, bubble.At.TOP_RIGHT)
	bubble_set_title("Test the Animation")
	bubble_add_text([
		"Test your animation by clicking the play button in the Animation panel.",
		"",
		"You should see the target smoothly move from left to right.",
		"",
		"If it doesn't work, check that:",
		"• Both %s [b]Keyframes[/b] are created" % bbcode_generate_icon_image_string(ICONS_MAP.keyframe),
		"• The timeline length is 1 second",
		"• The positions are set correctly"
	])
	complete_step()

	# Create more animations
	highlight_scene_nodes_by_name(["Target"])
	highlight_controls([interface.animation_player, interface.inspector_dock, interface.canvas_item_editor])
	bubble_move_and_anchor(interface.animation_player, Bubble.At.TOP_CENTER, 16, Vector2(0, -600))
	bubble_set_title("Create Additional Animations")
	bubble_add_text([
		"Let's create the left to right movement pattern. Create this animation:",
		"",
		"[b]straight_left:[/b]",
		"• Length: 1 second",
		"• 0s: Vector2(0, 0)",
		"• 1s: Vector2(-1200, 0)",
	])
	bubble_add_task(
		"Create the 'straight_right' and 'straight_left' animations",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var anim_player = scene_root.find_child("AnimationPlayer")
				if anim_player != null:
					var anim_library = anim_player.get_animation_library("")
					if anim_library != null:
						var has_right = anim_library.has_animation("straight_right")
						var has_left = anim_library.has_animation("straight_left")
						return 1 if has_right and has_left else 0
			return 0
	)
	complete_step()

	# Detailed wave animation
	highlight_scene_nodes_by_name(["Target"])
	highlight_controls([interface.animation_player, interface.inspector_dock, interface.canvas_item_editor])
	bubble_move_and_anchor(interface.animation_player, Bubble.At.TOP_CENTER, 16, Vector2(0, -600))
	bubble_set_title("Wave Animation Details")
	bubble_add_text([
		"For the wave_right animation, create these keyframes:",
		"",
		"• 0.0s: Vector2(0, 0)",
		"• 0.2s: Vector2(200, 150)",
		"• 0.4s: Vector2(400, -150)", 
		"• 0.6s: Vector2(600, 150)",
		"• 0.8s: Vector2(800, -150)",
		"• 1.0s: Vector2(1200, 150)",
		"",
		"To create a more fluid movement you can change the interpolation mode to &s 'Cubic' to the right of your position keyframe timeline." % bbcode_generate_icon_image_string(ICONS_MAP.cubic),
	])
	bubble_add_task(
		"Create the 'wave_right' animation",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var anim_player = scene_root.find_child("AnimationPlayer")
				if anim_player != null:
					var anim_library = anim_player.get_animation_library("")
					if anim_library != null:
						var has_wave = anim_library.has_animation("wave_right")
						return 1 if has_wave else 0
			return 0
	)
	complete_step()

	# Save target scene
	bubble_set_title("Save Target Scene")
	bubble_add_text([
		"Save your target scene with [b]Ctrl+S[/b].",
		"",
		"Make sure it's saved as 'target.tscn' in the scenes folder.",
		"",
		"Our target now has visual appearance, collision detection, and movement animations!"
	])
	complete_step()

func section_06_spawning_system() -> void:
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Creating the Spawning System")
	bubble_add_text([
		"Now we'll create the system that spawns targets at regular intervals.",
		"",
		"Our spawning system will:",
		"• Load and instantiate target scenes",
		"• Position targets randomly",
		"• Start their animations",
		"• Handle the time_added signal from targets"
	])
	complete_step()

	# Open zone script
	context_set_script()
	scene_open("res://gallery_shooter/scenes/zone.tscn")
	queue_command(func():
		var script_path = "res://gallery_shooter/scripts/zone.gd"
		if FileAccess.file_exists(script_path):
			var script_resource = load(script_path)
			EditorInterface.edit_resource(script_resource)
	)
	highlight_controls([interface.script_editor_code_panel])
	bubble_move_and_anchor(interface.script_editor_code_panel, Bubble.At.TOP_RIGHT)
	bubble_set_title("Update Zone Script - Add Variables")
	bubble_add_text([
		"We need to add some variables and functions to our zone script.",
		"",
		"Add this line at the top of your script (after extends):",
		""
	])
	bubble_add_code([
		"var target_scene = preload('res://gallery_shooter/scenes/target.tscn')"
	])
	bubble_add_text([
		"",
		"This preloads our target scene so we can instantiate it multiple times."
	])
	complete_step()

	# Add spawn function
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Create Spawn Function")
	bubble_add_text([
		"Add this function to create new targets:",
		""
	])
	bubble_add_code([
"func create_spawn():
	var new_spawn = Marker2D.new()
	var new_target = target_scene.instantiate()
	add_child(new_spawn)
	new_spawn.add_child(new_target)
	new_target.time_added.connect(_on_time_added)
	
	# Play animation
	var anim_player = new_target.get_node('AnimationPlayer')
	anim_player.play('straight_right')
	
	# Randomize speed
	anim_player.speed_scale = randf_range(0.2, 0.6)"
	])
	bubble_add_text([
		"",
		"This function:",
		"• Creates a marker node as a spawn point",
		"• Creates a new target instance",
		"• Adds it to the scene",
		"• Connects its signal to our zone",
		"• Starts the animation with random speed",
		"",
		"The addition of a spawner is necessary since the animation player overwrites the position of the targets.",
	])
	complete_step()

	# Add timer signal handler
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Add Timer Signal Handler")
	bubble_add_text([
		"Add this function to handle when the DelayTimer times out:",
		""
	])
	bubble_add_code([
"func _on_delay_timer_timeout():
	create_spawn()"
	])
	bubble_add_text([
		"",
		"This will be called every 1.5 seconds to spawn a new target."
	])
	complete_step()

	# Add time added handler
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Add Time Added Handler")
	bubble_add_text([
		"Add this function to handle when targets are shot:",
		""
	])
	bubble_add_code([
"func _on_time_added(time):
	$WorldTimer.start($WorldTimer.time_left + time)"
	])
	bubble_add_text([
		"",
		"This adds time to the game timer when a target is hit, extending gameplay!"
	])
	complete_step()

	# Connect DelayTimer signal
	highlight_scene_nodes_by_name(["DelayTimer"])
	highlight_controls([interface.node_dock_signals_button, interface.node_dock_signals_editor, interface.signals_dialog, interface.signals_dialog_ok_button, interface.inspector_tabs])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Connect DelayTimer Signal")
	bubble_add_text([
		"We need to connect the DelayTimer's timeout signal.",
		"",
		"Select the [b]DelayTimer[/b] node, then:",
		"1. Go to the 'Node' tab in the Inspector",
		"2. Find the 'timeout' signal",
		"3. Double-click it and connect to '_on_delay_timer_timeout'",
		"",
		"This will automatically spawn targets every 1.5 seconds."
	])
	complete_step()

	# Start the delay timer
	context_set_script()
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Start the DelayTimer")
	bubble_add_text([
		"Update your _ready() function to also start the DelayTimer:",
		""
	])
	bubble_add_code([
"func _ready():
	randomize()
	$WorldTimer.start(20)
	$DelayTimer.start()  # Add this line"
	])
	bubble_add_text([
		"",
		"Now the DelayTimer will start running and spawning targets!"
	])
	complete_step()

	# Add positional spawning
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Add Positional Variation")
	bubble_add_text([
		"Let's make targets spawn at different heights. Update your create_spawn function:",
		""
	])
	bubble_add_code([
"func create_spawn():
	var new_spawn = Marker2D.new()
	var new_target = target_scene.instantiate()
	add_child(new_spawn)
	new_spawn.add_child(new_target)
	new_target.time_added.connect(_on_time_added)
	
	# Set random spawn position
	new_spawn.position = Vector2(-30, randf_range(30, 600))
	
	# Play animation
	var anim_player = new_target.get_node('AnimationPlayer')
	anim_player.play('straight_right')
	
	# Randomize speed
	anim_player.speed_scale = randf_range(0.2, 0.6)"
	])
	bubble_add_text([
		"",
		"Now targets will spawn at random heights on the left side of the screen!"
	])
	complete_step()

	# Test the spawning system
	bubble_set_title("Test the Spawning System")
	bubble_add_text([
		"Save your script and test the game!",
		"",
		"You should see:",
		"• Targets spawning every 1.5 seconds",
		"• Targets moving from left to right",
		"• Different spawn heights",
		"• Random movement speeds",
		"",
		"If targets don't appear, check your script for typos and signal connections."
	])
	bubble_add_task(
		"Update zone script with spawning system",
		1,
		func(task: Task) -> int:
			var script_path = "res://gallery_shooter/scripts/zone.gd"
			if FileAccess.file_exists(script_path):
				var file_content = FileAccess.get_file_as_string(script_path)
				var has_preload = file_content.contains("target_scene = preload")
				var has_create_spawn = file_content.contains("func create_spawn")
				var has_timer_handler = file_content.contains("_on_delay_timer_timeout")
				var has_time_added = file_content.contains("_on_time_added")
				
				return 1 if has_preload and has_create_spawn and has_timer_handler and has_time_added else 0
			return 0
	)
	complete_step()

func section_07_input_system() -> void:
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Setting Up Mouse Input")
	bubble_add_text([
		"Currently our targets respond to keyboard input (ui_accept). Let's change this to mouse clicks.",
		"",
		"We'll:",
		"• Create a custom input action for mouse clicks",
		"• Update our target script to use mouse input",
		"• Test the shooting mechanics"
	])
	complete_step()

	# Open Input Map
	highlight_controls([interface.menu_bar])
	bubble_move_and_anchor(interface.menu_bar, Bubble.At.TOP_LEFT, 16.0, Vector2(350, 0))
	bubble_set_title("Open Input Map")
	bubble_add_text([
		"We need to create a custom input action for mouse clicks.",
		"",
		"1. In the menu bar, click '[b]Project → Project Settings[/b]'",
		"2. Click on the '[b]Input Map[/b]' tab",
		"",
		"In the Input Map, create a new action:",
		"1. Find the '[b]Add New Action[/b]' field at the top",
		"2. Type 'mouse_left' in this field",
		"3. Click the '[b]+ Add[/b]' button",
		"",
		"Now assign the left mouse button to this action:",
		"1. Find your new 'mouse_left' action in the list",
		"2. Click the '[b]+[/b]' button next to it",
		"3. Select '[b]Mouse Button[/b]' from the menu",
		"4. Choose '[b]Left Mouse Button[/b]'",
		"5. Click '[b]OK[/b]' to finish",
		"",
		"This creates a new input action we can reference in code."
	])
	complete_step()

	# Update target script
	context_set_script()
	scene_open("res://gallery_shooter/scenes/target.tscn")
	queue_command(func():
		var script_path = "res://gallery_shooter/scripts/target.gd"
		if FileAccess.file_exists(script_path):
			var script_resource = load(script_path)
			EditorInterface.edit_resource(script_resource)
	)
	highlight_controls([interface.script_editor_code_panel])
	bubble_move_and_anchor(interface.script_editor_code_panel, Bubble.At.TOP_RIGHT)
	bubble_set_title("Update Target Script for Mouse")
	bubble_add_text([
		"Update the _unhandled_input function in your target script:",
		"",
		"Change this line:"
	])
	bubble_add_code([
		"if event.is_action_pressed('ui_accept') && hovering:"
	])
	bubble_add_text([
		"",
		"To this:"
	])
	bubble_add_code([
		"if event.is_action_pressed('mouse_left') && hovering:"
	])
	bubble_add_text([
		"",
		"Now targets will respond to left mouse clicks instead of keyboard presses!"
	])
	complete_step()
	complete_step()

	# Test mouse input
	highlight_controls([interface.run_bar_play_button])
	bubble_set_title("Test Mouse Shooting")
	bubble_add_text([
		"Save your script and test the mouse input:",
		"",
		"1. Run the zone scene",
		"2. Wait for targets to spawn",
		"3. Click on a target with your mouse",
		"4. The target should disappear and time should be added",
		"",
		"If clicking doesn't work, check:",
		"• Input action is set up correctly",
		"• Target script is updated",
		"• Mouse signals are connected"
	])
	complete_step()

	# Add visual feedback
	bubble_set_title("Add Visual Feedback (Optional)")
	bubble_add_text([
		"For better player feedback, you can add visual changes when hovering:",
		""
	])
	bubble_add_code([
"func _on_mouse_entered():
	hovering = true
	modulate = Color(1.2, 1.2, 1.2)  # Brighten when hovered

func _on_mouse_exited():
	hovering = false
	modulate = Color(1.0, 1.0, 1.0)  # Return to normal"
	])
	bubble_add_text([
		"",
		"This makes targets slightly brighter when the mouse hovers over them."
	])
	complete_step()

func section_08_polishing() -> void:
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Polishing Your Gallery Shooter")
	bubble_add_text([
		"Let's add some final touches to make our gallery shooter feel more professional:",
		"",
		"• Custom mouse cursor (crosshair)",
		"• Game over detection",
		"• Improved target variety",
	])
	complete_step()

	# Custom cursor
	highlight_controls([interface.menu_bar])
	bubble_move_and_anchor(interface.menu_bar, Bubble.At.TOP_LEFT, 16.0, Vector2(350, 0))
	bubble_set_title("Add Custom Cursor")
	bubble_add_text([
		"A crosshair cursor makes the game feel more like a real shooter.",
		"",
		"1. Open '[b]Project → Project Settings[/b]'",
		"2. Go to '[b]General → Display → Mouse Cursor[/b]'",
		"3. Set '[b]Custom Image[/b]' to your crosshair texture",
		"4. Adjust '[b]Custom Image Hotspot[/b]' if needed (this is the point where the click happens)",
	])
	complete_step()

	# Improve target variety
	context_set_script()
	highlight_controls([interface.script_editor_code_panel])
	bubble_move_and_anchor(interface.script_editor_code_panel,Bubble.At.TOP_RIGHT)
	scene_open("res://gallery_shooter/scenes/zone.tscn")
	queue_command(func():
		var script_path = "res://gallery_shooter/scripts/zone.gd"
		if FileAccess.file_exists(script_path):
			var script_resource = load(script_path)
			EditorInterface.edit_resource(script_resource)
	)
	bubble_set_title("Add Animation Variety")
	bubble_add_text([
		"Make targets more interesting by using different animations:",
		""
	])
	bubble_add_code([
"func create_spawn():
	var new_spawn = Marker2D.new()
	var new_target = target_scene.instantiate()
	add_child(new_spawn)
	new_spawn.add_child(new_target)
	new_target.time_added.connect(_on_time_added)
	
	# Choose random animation
	var animations = ['straight_right', 'straight_left', 'wave_right']
	var chosen_anim = animations[randi() % animations.size()]
	
	# Set random spawn position
	if chosen_anim.contains('left'):
		new_spawn.position = Vector2(1180, randf_range(30, 600))
	else:
		new_spawn.position = Vector2(-30, randf_range(30, 600))
	
	var anim_player = new_target.get_node('AnimationPlayer')
	anim_player.play(chosen_anim)
	anim_player.speed_scale = randf_range(0.2, 0.6)"
	])
	bubble_add_text([
		"",
		"This randomly selects from available animations and changes the starting postion based on it."
	])
	complete_step()

	# Add game over detection
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Add Game Over Detection")
	bubble_add_text([
		"Add a game over system when the timer runs out:",
		""
	])
	bubble_add_code([
"func _process(_delta):
	# Update time display
	var time_left = $WorldTimer.time_left
	$CanvasLayer/Label.text = str(int(time_left))
	
	# Check for game over
	if time_left <= 0:
		game_over()

func game_over():
	$DelayTimer.stop()
	$CanvasLayer/Label.text = \"GAME OVER\"
	# Remove all remaining targets
	for child in get_children():
		if child.name.contains('Marker2D'):
			child.queue_free()"
	])
	complete_step()

	# Target cleanup
	scene_open("res://gallery_shooter/scenes/target.tscn")
	highlight_scene_nodes_by_name(["AnimationPlayer"])
	highlight_controls([interface.script_editor_code_panel, interface.node_dock_signals_button, interface.node_dock_signals_editor, interface.signals_dialog, interface.signals_dialog_ok_button, interface.inspector_tabs])
	bubble_set_title("Add Target Cleanup")
	bubble_add_text([
		"Targets that move off-screen should be removed to save memory.",
		"",
		"Add this to your target script:",
		""
	])
	bubble_add_code([
"func _on_animation_player_animation_finished(_anim_name):
	get_parent().queue_free()"
	])
	bubble_add_text([
		"",
		"This automatically removes targets with their spawner when their movement animation completes.",
		"",
		"Don't forget to connect the AnimationPlayer's 'animation_finished' signal to this function in the Node tab of the Inspector."
	])
	complete_step()
	
	# Configure background
	scene_open("res://gallery_shooter/scenes/zone.tscn")
	highlight_controls([interface.inspector_dock, interface.scene_dock, interface.canvas_item_editor])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Configure Background")
	bubble_add_text([
		"At last, add a background to the game. Add a Sprite2D node to the zone and configure it:",
		"",
		"1. In the Inspector, set the '[b]Texture[/b]' to your background image",
		"2. Position and scale it to cover the entire screen",
	])
	bubble_add_task(
		"Add a texture to the background Sprite2D",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var sprite_node = scene_root.find_child("Sprite2D")
				if sprite_node != null:
					var texture = sprite_node.get("texture")
					return 1 if texture != null else 0
			return 0
	)
	complete_step()

	# Difficulty scaling
	context_set_script()
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Add Difficulty Scaling (Optional)")
	bubble_add_text([
		"Make the game progressively harder by decreasing spawn time:",
		""
	])
	bubble_add_code([
"var spawn_time = 1.5

func _ready():
	randomize()
	$WorldTimer.start(20)
	$DelayTimer.wait_time = spawn_time
	$DelayTimer.start()

func _on_delay_timer_timeout():
	create_spawn()
	# Gradually decrease spawn time (increase difficulty)
	spawn_time = max(0.3, spawn_time - 0.05)
	$DelayTimer.wait_time = spawn_time"
	])
	bubble_add_text([
		"",
		"This makes targets spawn faster over time, increasing challenge!"
	])
	complete_step()

	# Final testing
	bubble_set_title("Final Testing")
	bubble_add_text([
		"Test your complete gallery shooter:",
		"",
		"✓ Targets spawn at regular intervals",
		"✓ Mouse clicks destroy targets",
		"✓ Time is added when targets are hit",
		"✓ Game ends when timer reaches zero",
		"✓ Custom cursor appears",
		"✓ Different movement patterns work",
		"",
		"Congratulations! You have a working gallery shooter!"
	])
	complete_step()

func section_09_conclusion() -> void:
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Congratulations!")
	bubble_add_text([
		bbcode_wrap_font_size("[center][b]You've Built Your First Gallery Shooter![/b][/center]", 28),
		"",
		"[center]You've successfully created:[/center]",
		"• [color=green][b]A timer-based game system[/b][/color] with countdown and game over",
		"• [color=purple][b]Interactive targets[/b][/color] with mouse detection and animations", 
		"• [color=yellow][b]A spawning system[/b][/color] that creates targets automatically",
		"• [color=cyan][b]Custom input handling[/b][/color] with mouse controls"
	])
	complete_step()

	# Next steps
	bubble_set_title("Ideas for Expansion")
	bubble_add_text([
		"Here are some ways you could expand your gallery shooter:",
		"",
		"[b]Gameplay Features:[/b]",
		"• Create different target types with varying point values",
		"• Add power-ups that appear occasionally",
		"",
		"[b]Visual & Audio:[/b]",
		"• Add sound effects for shooting and hits",
		"• Create particle effects when targets are destroyed",
		"• Add background music",
		"• Add more animation variety"
	])
	complete_step()

	# Learning resources
	bubble_set_title("Learning Resources")
	bubble_add_text([
		"To continue your game development journey:",
		"",
		"[b]Official Documentation:[/b]",
		"• [url=https://docs.godotengine.org]Godot Documentation[/url]",
		"• [url=https://docs.godotengine.org/en/stable/tutorials/2d/index.html]2D Game Tutorials[/url]",
		"",
		"[b]Community Resources:[/b]",
		"• [url=https://godotengine.org/community]Godot Community[/url]",
		"• [url=https://www.youtube.com/c/GDQuest]GDQuest YouTube Channel[/url]",
		"• [url=https://kidscancode.org/godot_recipes/]Godot Recipes[/url]"
	])
	complete_step()

	# Final congratulations
	if BUBBLE_BACKGROUND:
		bubble_set_background(BUBBLE_BACKGROUND)
	bubble_set_title("")
	bubble_add_text([
		bbcode_wrap_font_size("[center][b]🎯 Tutorial Complete! 🎯[/b][/center]", 32),
		"",
		"[center]You now have experience with the signal system, input handling, game object management and most importantly the animation player![/center]",
		"[center]Keep practicing and building more games to improve your skills.[/center]",
		"",
		"[center][b]Happy Game Development![/b][/center]"
	])
	bubble_set_footer(CREDITS_FOOTER)
	complete_step()
