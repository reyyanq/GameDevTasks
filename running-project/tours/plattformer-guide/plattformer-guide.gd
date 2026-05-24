# godot_platformer_tour.gd
extends "res://addons/godot_tours/tour.gd"

### Changes that need to be made outside this file after moving
### Change code highlighting colors
### Fix open scene:
	#queue_command(func() -> void:
		#if path in EditorInterface.get_open_scenes():
			#EditorInterface.open_scene_from_path(path)
		#else:
			#EditorInterface.open_scene_from_path(path)
	#) 


const BUBBLE_BACKGROUND := preload("res://addons/godot_tours/assets/images/bubble-background.png") # Optional custom background
const CREDITS_FOOTER := "[center]2D Platformer Tutorial · Learn Game Development in Godot[/center]"

# Scene and asset paths - updated for platformer_game folder
var main_scene := "res://platformer_game/scenes/main.tscn"
var player_scene := "res://platformer_game/scenes/player.tscn"
var player_script := "res://platformer_game/scripts/player.gd"
var collectable_scene := "res://platformer_game/scenes/collectable.tscn"
var collectable_script := "res://platformer_game/scripts/collectable.gd"

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
	point = "res://tours/plattformer-guide/assets/Points/Crystal/01.png",
	plattform = "res://tours/plattformer-guide/assets/World/Terrain/Flatt_Plattform.png",
	plattform_tile = "res://tours/plattformer-guide/assets/World/Terrain/Plattform_Middle.png",
	player = "res://tours/plattformer-guide/assets/Player/01-Idle/player_large.png",
	group = "res://addons/godot_tours/bubble/assets/icons/Group.svg",
	loop = "res://addons/godot_tours/bubble/assets/icons/Loop.svg",
	autoplay = "res://addons/godot_tours/bubble/assets/icons/AutoPlay.svg",
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
	section_01_introduction()
	section_02_project_setup()
	section_03_project_settings()
	section_04_player_character()
	section_05_world_creation()
	section_06_collectables()
	section_07_conclusion()

func bbcode_generate_large_icon(image_filepath: String, width: int = 48, height: int = 48) -> String:
	return "[img=%sx%s]%s[/img]" % [width, height, image_filepath]

func section_01_introduction() -> void:
	# Welcome screen - combined introduction
	context_set_2d()
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	if BUBBLE_BACKGROUND:
		bubble_set_background(BUBBLE_BACKGROUND)
	bubble_set_title("")
	bubble_add_text([bbcode_wrap_font_size("[center][b]Create Your First 2D Platformer in Godot[/b][/center]", 28), ""])
	if FileAccess.file_exists("res://assets/Level.png"):
		bubble_add_texture(preload("res://tours/plattformer-guide/assets/Level.png"), 300.0)
	bubble_add_text([
		"",
		"[center]In this tutorial, you'll learn game development with Godot by creating a 2D platformer.[/center]",
		"[center]By the end of this tutorial, you'll have a working side-scrolling 2D platformer where the player controls a character that runs, jumps across platforms, and collects points.[/center]",
		""
	])
	bubble_set_footer(CREDITS_FOOTER)
	complete_step()
	
	bubble_move_and_anchor(interface.base_control, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Overview")
	bubble_add_text([
		"Before diving into the implementation, let’s look at what makes up our 2D platformer:",
		"",
		"[b]%s   Player Character[/b]" % bbcode_generate_large_icon(ICONS_MAP.player, 48, 56),
		"A character that responds to input controls. It can move left and right, jump, and interact with the environment through physics and collision detection.",
		"",
		"[b]%s   Game World[/b]" % bbcode_generate_large_icon(ICONS_MAP.plattform_tile, 48, 48),
		"The level environment made of platforms, walls, and obstacles. This includes the visual design and collision boundaries that define where the player can and cannot go.",
		"",
		"[b]%s Interactive Elements[/b]" % bbcode_generate_large_icon(ICONS_MAP.point, 48),
		"Objects the player can interact with, such as collectible items, moving platforms, or enemies. These add gameplay objectives and challenges.",
	])
	complete_step()
	
	# Tutorial structure
	bubble_set_title("Tutorial Structure")
	bubble_add_text([
		"Based on that we'll build the game step by step:",
		"",
		"[b]1. Project Setup[/b] - Organize files and configure settings",
		"[b]2. Player[/b] - Create movement and animations",
		"[b]3. Level Design[/b] - Build the game world using tilemaps",
		"[b]4. Game Systems[/b] - Add collectibles and scoring",
		"",
		"Each section builds on the previous one, so you'll have a working game at each stage.",
		"",
		"[center]Let's start building.[/center]"
	])
	complete_step()

func section_02_project_setup() -> void:
	# Project creation step
	#bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_title("Project Organization")
	bubble_add_text([
		"Before we start coding, we need to organize our project files.",
		"",
		"Good organization makes it easier to find files as your project grows. It also makes your code easier to understand for others (and your future self).",
		"",
		"We'll create folders to separate different types of files."
	])
	complete_step()

	# Focus on FileSystem dock with better positioning
	highlight_controls([interface.filesystem_dock])
	bubble_move_and_anchor(interface.filesystem_dock, Bubble.At.TOP_RIGHT, 16.0, Vector2(550, 0))
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title("FileSystem Dock")
	bubble_add_text([
		"The FileSystem dock shows all files and folders in your project.",
		"",
		"Right now it probably just contains the default project and tours files. We'll add our own organization structure.",
		"",
		"This is where you'll access all your game assets: images, sounds, scripts, and scene files."
	])
	complete_step()

	# Create platformer-specific folders
	bubble_set_title("Create Project Folders")
	highlight_controls([interface.filesystem_dock])
	bubble_add_text([
		"We'll create a folder structure for our platformer game:",
		"",
		"[code]res://platformer_game/[/code]",
		"[code]├── assets/     # Images, sounds, and media[/code]",
		"[code]├── scenes/     # Game scenes (.tscn files)[/code]",
		"[code]└── scripts/    # Code files (.gd files)[/code]",
		"",
		"This keeps our platformer organized and separate from other projects."
	])
	complete_step()

	# Create main platformer folder first
	highlight_controls([interface.filesystem_dock])
	bubble_add_text([
		"First, create the main 'platformer_game' folder.",
		"",
		"Right-click in the FileSystem and select 'New Folder', then name it 'platformer_game'."
	])
	bubble_add_task(
		"Create the 'platformer_game' folder",
		1,
		func(task: Task) -> int:
			return 1 if DirAccess.dir_exists_absolute("res://platformer_game") else 0
	)
	complete_step()

	# Create subfolders task
	highlight_controls([interface.filesystem_dock])
	bubble_add_text([
		"Now create three subfolders inside 'platformer_game':",
		"",
		"• [b]assets[/b] - For images, sounds, and other media files",
		"• [b]scenes[/b] - For .tscn scene files (levels, characters, UI)",
		"• [b]scripts[/b] - For .gd script files (game logic and behavior)",
		"",
		"Right-click on the 'platformer_game' folder to create each one."
	])
	bubble_add_task(
		"Create 'assets', 'scenes', and 'scripts' folders inside 'platformer_game'",
		1,
		func(task: Task) -> int:
			return 1 if (
				DirAccess.dir_exists_absolute("res://platformer_game/assets") and
				DirAccess.dir_exists_absolute("res://platformer_game/scenes") and
				DirAccess.dir_exists_absolute("res://platformer_game/scripts")
			) else 0
	)
	complete_step()

	# Explain the benefits
	bubble_set_title("Why Organize Like This?")
	bubble_add_text([
		"This structure provides several benefits:",
		"",
		"[b]Easy Navigation[/b] - You always know where to find specific file types",
		"[b]Faster Development[/b] - Less time searching for files",
		"[b]Team Work[/b] - Others can easily understand your project structure",
		"",
		"There are other ways to structure your projects, but this method is particularly useful for small projects.."
	])
	complete_step()

func section_03_project_settings() -> void:
	bubble_move_and_anchor(interface.menu_bar, Bubble.At.TOP_LEFT, 16.0, Vector2(350, 0))
	highlight_controls([interface.menu_bar])
	bubble_set_title("The Project Settings")
	bubble_add_text([
		"Before we start creating content, we need to configure some graphics settings.",
		"",
		"These settings control how Godot displays images in your game. If you're using pixel art, these settings are especially important.",
		"",
		"Even if you're not using pixel art, it's good to understand what these settings do."
	])
	complete_step()

	# Open Project Settings
	highlight_controls([interface.menu_bar])
	bubble_set_title("Open and Configure Project Settings")
	bubble_add_text([
		"Open the Project Settings dialog and configure the texture filtering.",
		"",
		"1. In the menu bar, click [b]Project → Project Settings[/b]",
		"2. Navigate to [b]General → Rendering → Textures[/b]",
		"3. Find 'Default Texture Filter'",
		"4. Change it from 'Linear' to '[b]Nearest[/b]'",
		"5. Click 'Close' when finished",
		"",
		"This setting applies to all textures in your project unless you override it on individual images."
	])
	bubble_add_task(
		"Open Project Settings, change Default Texture Filter to 'Nearest', and close the dialog",
		1,
		func(task: Task) -> int:
			# Check if the setting has been changed (this persists even after closing)
			var project_settings_value = ProjectSettings.get_setting("rendering/textures/canvas_textures/default_texture_filter", 1)
			# 0 = Nearest, 1 = Linear (default)
			return 1 if project_settings_value == 0 else 0
	)
	complete_step()

	# Rendering settings explanation with more detail
	bubble_set_title("Texture Filtering Explained")
	bubble_add_text([
		"[b]What is texture filtering?[/b]",
		"When images are scaled, the computer has to decide how to handle the pixels.",
		"",
		"• [b]Linear filtering[/b] smooths and blends pixels together. Good for realistic graphics.",
		"• [b]Nearest filtering[/b] keeps pixels sharp and distinct. Better for pixel art.",
		"",
		"We'll use Nearest filtering to keep our graphics crisp."
	])
	complete_step()

	# Optional display settings
	bubble_set_title("Optional: Window Scale")
	bubble_add_text([
		"If you want to make your game window larger, you can also adjust:",
		"",
		"1. Go to [b]General → Display → Window[/b]",
		"2. Change the 'Scale' setting to make the window bigger",
		"",
		"Click 'Close' when you're finished."
	])
	complete_step()

func section_04_player_character() -> void:
	# Introduction to player character
	context_set_2d()
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Creating the Player Character")
	if FileAccess.file_exists("res://tours/plattformer-guide/assets/Player/01-Idle/player_large.png"):
		bubble_add_texture(preload("res://tours/plattformer-guide/assets/Player/01-Idle/player_large.png"), 300.0)
	bubble_add_text([
		"The player character is at the heart of any platformer game. Or really, of most games.",
		"We'll create a character that can:",
		"• Move left and right",
		"• Jump and fall with gravity",
		"• Play animations based on movement",
		"• Is followed by the camera as it moves",
		"",
		"Before we start with the player character, though, we'll have to set up a basic environment in which we can use it."
	])
	complete_step()
	
	
	# Create new scene
	highlight_controls([interface.filesystem_tree, interface.main_screen_tabs])
	highlight_filesystem_paths(["platformer_game", "platformer_game/scenes"])
	bubble_move_and_anchor(interface.filesystem_dock, Bubble.At.TOP_RIGHT, 16.0, Vector2(550, 50))
	bubble_set_title("Setting up a test scene")
	bubble_add_text([
		"Let's create a new scene for our player to move in.",
		"Right-click on the newly created 'scenes' folder in the file system and select '[b]Create New → Scene[/b]'.",
		"Alternatively, you can click the '+' button in the scene tab bar. However, this method requires manual saving of the scene.",
		"",
		"In the pop-up, select '2D Scene' as a root-node and name it 'test_scene'."
	])
	bubble_add_task(
		"Create a new scene called 'test_scene' in the scenes folder", 
		1,
		func(task: Task) -> int:
			return 1 if FileAccess.file_exists("res://platformer_game/scenes/test_scene.tscn") else 0
	)
	complete_step()

	# Add CharacterBody2D
	highlight_controls([interface.scene_dock, interface.node_create_dialog_search_bar, interface.node_create_dialog_button_create, interface.node_create_dialog_node_tree])
	scene_open("res://platformer_game/scenes/test_scene.tscn")
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300,50))
	bubble_set_title("Add a CharacterBody2D")
	bubble_add_text([
		"CharacterBody2D is perfect for platformer characters because it:",
		"• Provides built-in collision handling",
		"• Includes useful methods like [code]is_on_floor()[/code]",
		"• Has smooth movement with [code]move_and_slide()[/code]",
		"",
		"To add one to the scene, click on the '+' button in the scene_dock and search '[b]CharacterBody2D[/b]' in the create dialog.",
	])
	bubble_add_task_press_button(interface.scene_dock_button_add)
	mouse_move_by_callable(
		get_control_global_center.bind(interface.scene_tabs),  # From center of viewport
		get_control_global_center.bind(interface.scene_dock_button_add)  # To the add button
	)
	mouse_click(1)
	bubble_add_task(
		"Add a CharacterBody2D",
		1,
		func(task: Task) -> int:
		var scene_root = EditorInterface.get_edited_scene_root()
		if scene_root:
			var characterbody2d_node = scene_root.find_child("CharacterBody2D")
			return 1 if characterbody2d_node != null else 0
		return 0
	)
	complete_step()

	# Create the node
	scene_open("res://platformer_game/scenes/test_scene.tscn")
	highlight_scene_nodes_by_path(["CharacterBody2D"])
	bubble_add_text(["Now rename it to 'Player'. In the scene tree, node names follow PascalCase."])
	bubble_add_task(
		"Name the [b]CharacterBody2D[/b] 'Player'",
		1,
		func(task: Task) -> int:
		var scene_root = EditorInterface.get_edited_scene_root()
		if scene_root:
			var characterbody2d_node = scene_root.find_child("Player")
			return 1 if characterbody2d_node != null else 0
		return 0
	)
	complete_step()

	# Add child nodes
	highlight_scene_nodes_by_name(["Player"])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300,50))
	bubble_set_title("Add Child Nodes")
	bubble_add_text([
		"Now we need to add child nodes to our Player:",
		"",
		"• [b]Sprite2D[/b] - For the character visuals",
		"• [b]CollisionShape2D[/b] - For collision detection",
		"• [b]Camera2D[/b] - So the camera follows the player",
		"",
		"Right-click on the Player and select 'Add Child' to add each of these or left click it and press the '+' button again."
	])
	
	bubble_add_task(
   "Add [b]Sprite2D[/b], [b]CollisionShape2D[/b], and [b]Camera2D[/b] as children of the Player",
   1,
   func(task: Task) -> int:
		var scene_root = EditorInterface.get_edited_scene_root()
		var player_node = scene_root.find_child("Player")
		if scene_root and player_node:
			var has_animated_sprite = player_node.find_child("Sprite2D") != null
			var has_collision_shape = player_node.find_child("CollisionShape2D") != null
			var has_camera = player_node.find_child("Camera2D") != null
			return 1 if has_animated_sprite and has_collision_shape and has_camera else 0
		return 0
	)
	complete_step()
	
	# Setup Camera2D
	highlight_scene_nodes_by_name(["Camera2D"])
	highlight_controls([interface.inspector_dock])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Configure the Camera")
	bubble_add_text([
		"If your assets are very small like pixel art, select the [b]Camera2D[/b] node and give it a higher zoom so to see them.",
		"",
		"In the Inspector set '[b]Zoom[/b]' to (3, 3) so we can see the player clearly"
	])
	complete_step()
	
	# Setup Sprite2D
	highlight_scene_nodes_by_name(["Sprite2D"])
	highlight_controls([interface.inspector_dock, interface.filesystem_dock])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550,0))
	bubble_set_title("Add a Texture")
	bubble_add_text([
		"Select the [b]Sprite2D[/b] node and give it a texture.",
		"In the Inspector, find the '[b]Texture[/b]' property.",
		"To add a texture you can either click on it and pick 'Load...' or simply drag and drop the image in.",
	])
	bubble_add_task(
	   "Add a texture to the [b]Sprite2D[/b] node",
	   1,
	   func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var sprite2d_node = scene_root.find_child("Sprite2D")
				if sprite2d_node != null:
					var texture = sprite2d_node.get("texture")
					return 1 if texture != null else 0
			return 0
	)
	complete_step()
	

	# Setup CollisionShape2D
	context_set_2d()
	highlight_scene_nodes_by_name(["CollisionShape2D"])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550,0))
	highlight_controls([interface.inspector_dock, interface.canvas_item_editor])
	bubble_set_title("Configure the Collision Shape")
	bubble_add_text([
		"Select the [b]CollisionShape2D[/b] node and set up its shape.",
		"In the Inspector, find the '[b]Shape[/b]' property.",
		"Create a '[b]New RectangleShape2D[/b]' or '[b]New CapsuleShape2D[/b]'.",
		"Size it on the canvas to match your character sprite.",
		"",
		"Tip: Make it slightly smaller than the visual. Usually that translates better in game."
	])
	bubble_add_task(
	"Configure the [b]CollisionShape2D[/b] with a shape",
	1,
	func(task: Task) -> int:
		var scene_root = EditorInterface.get_edited_scene_root()
		if scene_root:
			var collision_shape_node = scene_root.find_child("CollisionShape2D")
			if collision_shape_node != null:
				var shape = collision_shape_node.get("shape")
				return 1 if shape != null else 0
		return 0
	)
	complete_step()

	# Add script to player
	highlight_scene_nodes_by_name(["Player"])
	highlight_controls([interface.scene_dock.get_children()[0].get_children()[3]])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300,50))
	bubble_set_title("Add Player Script")
	bubble_add_text([
		"Now we need to add a script to control our player's movement.",
		"Right-click on the [b]Player[/b] node and select '[b]Attach Script[/b]' %s." % bbcode_generate_icon_image_string(ICONS_MAP.script),
		"Save the script as 'player.gd' in the scripts folder."
	])
	bubble_add_task(
		"Attach a script to the [b]Player[/b] node",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			var player_node = scene_root.find_child("Player")
			if player_node:
				return 1 if player_node.get_script() != null else 0
			return 0
	)
	complete_step()

	# Switch to script editor
	context_set_script()
	queue_command(func():
		var script_path = "res://platformer_game/scripts/player.gd"
		if FileAccess.file_exists(script_path):
			var script_resource = load(script_path)
			EditorInterface.edit_resource(script_resource)
	)
	highlight_controls([interface.script_editor_code_panel])
	highlight_code(0,0)
	bubble_move_and_anchor(interface.script_editor_code_panel, Bubble.At.TOP_RIGHT)
	bubble_set_title("Understanding the Default Script")
	bubble_add_text([
		"Great! The script editor opened with a basic template. Now we can implement the basic movement for our player.",
		"",
		"You should see:"
	])
	bubble_add_code(["extends CharacterBody2D"])
	bubble_add_text([
		"",
		"This line tells Godot that our script controls a [b]CharacterBody2D[/b] node and inherits all its built in methods. This gives us access to special movement functions."
	])
	complete_step()
	
	# Step 1: Define what the player needs to do
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Planning Our Player Movement")
	bubble_add_text([
		"Before writing code, let's think about what our player needs to do:",
		"",
		"1. [b]Fall down[/b] when not on the ground (gravity)",
		"2. [b]Jump up[/b] when we press a key",
		"3. [b]Move left and right[/b] with arrow keys",
		"4. [b]Stop moving[/b] when we release keys",
		"",
		"We need a function that runs constantly to handle this movement."
	])
	complete_step()
	
	# Step 2: Add the physics process function
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Create the Movement Function")
	bubble_add_text([
		"In Godot, we use [code]_physics_process()[/code] for movement code. This function is our game loop with the addition of delta.",
		"",
		"Add this function below the extends line:",
		""])
	bubble_add_code(["func _physics_process(delta):
	pass"])
	bubble_add_text([
		"",
		"[b]_physics_process[/b] runs 60 times per second.",
		"[b]delta[/b] is the time since the last frame, we'll use this for smooth movement."
	])
	complete_step()
	
	# Step 3: Add gravity
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Step 1: Add Gravity")
	bubble_add_text([
		"First, let's make our player fall when they're not on the ground.",
		"",
		"Replace [code]pass[/code] with:",
		""
	])
	bubble_add_code([
		"if not is_on_floor():
	velocity += get_gravity() * delta",
	])
	bubble_add_text([
		"",
		"[b]is_on_floor()[/b] checks if the [b]CharacterBody2D[/b] is touching ground",
		"[b]velocity[/b] is a built-in vector that controls how fast and in what direction a [b]CharacterBody2D[/b] moves",
		"[b]get_gravity()[/b] gets the gravity strength from project settings"
	])
	complete_step()

	# Step 4: Add jumping
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Step 2: Add Jumping")
	bubble_add_text([
		"Now let's add jumping when the player presses a key.",
		"",
		"Add this code after the gravity code:",
		"",
	])
	bubble_add_code([
		"if Input.is_action_just_pressed(\"ui_accept\") and is_on_floor():
	velocity.y = -300.0"
	])
	bubble_add_text([
		"",
		"[b]Input.is_action_just_pressed[/b] detects when a key is first pressed",
		"[b]\"ui_accept\"[/b] is Space or Enter key",
		"[b]velocity.y = -300[/b] makes the player jump up (negative = up)"
	])
	complete_step()

	# Step 5: Add horizontal movement
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Step 3: Add Left/Right Movement")
	bubble_add_text([
		"Now for left and right movement with arrow keys.",
		"",
		"Add this code next:",
		""
	])
	bubble_add_code([
"var direction = Input.get_axis(\"ui_left\", \"ui_right\")
if direction:
	velocity.x = direction * 200.0
else:
	velocity.x = move_toward(velocity.x, 0, 200.0)",
	])
	bubble_add_text([
		"",
		"[b]get_axis[/b] returns -1 (left), 0 (no input), or 1 (right)",
		"[b]velocity.x[/b] controls horizontal speed",
		"[b]move_toward[/b] smoothly stops the player when no keys are pressed"
	])
	complete_step()

	# Step 6: Apply the movement
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Step 4: Apply the Movement")
	bubble_add_text([
		"Finally, we need to actually move the player.",
		"",
		"Add this as the last line of the function:",
		""
	])
	bubble_add_code([
		"move_and_slide()",
	])
	bubble_add_text([
		"",
		"This crucial function:",
		"• Actually moves the character",
		"• Handles collisions with walls and floors",
		"• Makes the player slide along surfaces",
		"• Updates collision detection",
		"",
		"Without this, the player won't move at all!"
	])
	complete_step()
	
	
	# Step 7: Clean Up the Code
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Step 5: Clean Up the Code")
	bubble_add_text([
		"Let's improve our code a bit to make it more readable and maintainable.",
		"",
		"We'll:",
		"• Replace magic numbers with named constants",
		"• Add a class name so other scripts can reference our player",
		"",
		"Replace the magic numbers with these constants and add a class to the player for later reference:"
	])
	bubble_add_code([
"class_name Player

const SPEED = 200.0
const JUMP_VELOCITY = -300.0"
	])
	bubble_add_text([
		"• [b]class_name Player[/b] - Allows other scripts to reference this as 'Player' type",
		"• [b]const SPEED[/b] - Makes speed easy to adjust and read",
		"• [b]const JUMP_VELOCITY[/b] - Makes jump velocity easy to adjust and read"
	])
	complete_step()


	# Step 8: Save the code
	bubble_set_title("Test Your Code!")
	bubble_add_text([
		"Save your script by pressing [b]Ctrl+S[/b]",
		"",
		"Your complete code should look like this:",
		"",
	])
	bubble_add_code([
"class_name Player
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed(\"ui_accept\") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction = Input.get_axis(\"ui_left\", \"ui_right\")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()"
	])
	bubble_add_task(
	"Save the script with the complete movement code",
	1,
	func(task: Task) -> int:
		var script_path = "res://platformer_game/scripts/player.gd"
		if FileAccess.file_exists(script_path):
			var file_content = FileAccess.get_file_as_string(script_path)
			# Check for key components of the movement code
			var has_extends = file_content.contains("extends CharacterBody2D")
			var has_physics_process = file_content.contains("_physics_process")
			var has_gravity = file_content.contains("get_gravity()")
			var has_jump = file_content.contains("ui_accept")
			var has_movement = file_content.contains("get_axis")
			var has_move_and_slide = file_content.contains("move_and_slide()")
			
			return 1 if has_extends and has_physics_process and has_gravity and has_jump and has_movement and has_move_and_slide else 0
		return 0
)
	complete_step()

	# Test the player
	context_set_2d()
	highlight_controls([interface.canvas_item_editor_toolbar_group_button, interface.run_bar_play_button, interface.canvas_item_editor_viewport, interface.scene_dock])
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_title("Test the Player")
	bubble_add_text([
		"Let's test our player character!",
		"We need to add a simple ground platform to our test scene.",
		"",
		"Create add a platform like this:",
		"",
		"[code]TestScene (Node2D)[/code]",
		"[code]├── Player (CharacterBody2D)[/code]",
		"[code]└── Platform (StaticBody2D)[/code]",
		"[code]    ├── CollisionShape2D[/code]",
		"[code]    └── Sprite2D[/code]",
		"",
		"Before moving the platform under the player, left-click the parent node and press the %s button." % bbcode_generate_icon_image_string(ICONS_MAP.group),
	])
	bubble_add_task(
	"Create a scene with Player instance and Platform with collision",
	1,
	func(task: Task) -> int:
		var scene_root = EditorInterface.get_edited_scene_root()
		if scene_root:
			var player_node = scene_root.find_child("Player")
			var platform_node = scene_root.find_child("Platform")
			if platform_node == null:
				platform_node = scene_root.find_child("StaticBody2D")
			if player_node and platform_node:
				var platform_collision = platform_node.find_child("CollisionShape2D")
				return 1 if platform_collision != null else 0
		return 0
	)
	bubble_add_task_press_button(interface.run_bar_play_button)
	complete_step()
	
		# Add animation
	# Change to AnimatedSprite2D
	highlight_scene_nodes_by_name(["Sprite2D"])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title("Upgrade to AnimatedSprite2D")
	bubble_add_text([
		"Now we will animate our character, for that we need to change our Sprite2D to an AnimatedSprite2D.",
		"",
		"Right-click on the [b]Sprite2D[/b] node and select '[b]Change Type[/b]'.",
		"Search for 'AnimatedSprite2D' and select it.",
		"",
		"This allows us to play different simple animations like idle, running, and jumping."
	])
	bubble_add_task(
		"Change Sprite2D to AnimatedSprite2D and rename it to AnimatedSprite2D",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var player_node = scene_root.find_child("Player")
				if scene_root.name == "Player": player_node = scene_root
				if player_node:
					var animated_sprite = player_node.find_child("AnimatedSprite2D")
					return 1 if animated_sprite != null else 0
			return 0
	)
	complete_step()

	# Setup SpriteFrames
	highlight_scene_nodes_by_name(["AnimatedSprite2D"])
	highlight_controls([interface.inspector_dock])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Create SpriteFrames Resource")
	bubble_add_text([
		"Select the [b]AnimatedSprite2D[/b] node.",
		"",
		"In the Inspector, find '[b]Sprite Frames[/b]' and click '<empty>'.",
		"Select '[b]New SpriteFrames[/b]' to create an animation resource.",
		"",
		"Click on the SpriteFrames resource to open the animation editor at the bottom."
	])
	bubble_add_task(
		"Create a SpriteFrames resource for the AnimatedSprite2D",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var player_node = scene_root.find_child("Player")
				if scene_root.name == "Player": player_node = scene_root
				if player_node:
					var animated_sprite = player_node.find_child("AnimatedSprite2D")
					if animated_sprite:
						var sprite_frames = animated_sprite.get("sprite_frames")
						return 1 if sprite_frames != null else 0
			return 0
	)
	complete_step()

	# Basic animation setup
	var spriteframes_editor = interface.logger.get_parent().get_parent().get_children()[0].get_children()[9]
	var spriteframes_editor_button = interface.bottom_buttons_container.get_children()[9]
	highlight_controls([spriteframes_editor, spriteframes_editor_button])
	bubble_move_and_anchor(interface.animation_player, Bubble.At.TOP_CENTER, 16, Vector2(0, -600))
	bubble_set_title("Set Up Basic Animation")
	bubble_add_text([
		"The SpriteFrames editor should now be open at the bottom.",
		"",
		"For now, we'll create a simple 'run' and 'idle' animation:",
		"1. Drag your animation frames as seperate images into the animation frames area",
		"2. Set the FPS to something like 5-10",
		"3. Enable the loop button %s if it isn't already" % bbcode_generate_icon_image_string(ICONS_MAP.loop),
		"4. Name the animations 'run' and 'idle'", 
		"",
		"You can add additional animations for jumping or falling if you have the sprite frames for it."
	])
	bubble_add_task(
	"Create 'run' and 'idle' animations",
	1,
	func(task: Task) -> int:
		var scene_root = EditorInterface.get_edited_scene_root()
		if scene_root:
			var player_node = scene_root.find_child("Player")
			if scene_root.name == "Player": player_node = scene_root
			if player_node:
				var animated_sprite = player_node.find_child("AnimatedSprite2D")
				if animated_sprite:
					var sprite_frames = animated_sprite.get("sprite_frames")
					if sprite_frames:
						if sprite_frames.has_animation("run") and sprite_frames.get_frame_count("run") > 0:
							if sprite_frames.has_animation("idle") and sprite_frames.get_frame_count("idle") > 0:
								return 1 
		return 0
	)
	complete_step()
	
	# Animation code - Part 1
	context_set_script()
	queue_command(func():
		var script_path = "res://platformer_game/scripts/player.gd"
		if FileAccess.file_exists(script_path):
			var script_resource = load(script_path)
			EditorInterface.edit_resource(script_resource)
	)
	highlight_controls([interface.script_editor_code_panel])
	highlight_code(10)
	bubble_move_and_anchor(interface.script_editor_code_panel, Bubble.At.TOP_RIGHT)
	bubble_set_title("Call our animations in code")
	bubble_add_text([
		"",
		"Let's add the idle and running animation to the movement section.",
		"To do this we need to access our [b]AnimatedSprite2D[/b] node and use the built-in [b]'play()'[/b] method.",
		"Place these lines respectively under the if statement [code]if direction:[/code] and its 'else' block:"
	])
	bubble_add_code([
	"$AnimatedSprite2D.play(\"run\")",
	"$AnimatedSprite2D.play(\"idle\")"
	])
	bubble_add_text([
		"• [b]$[/b] lets us access the node. It is the shorthand for the built-in method get_node().",
		"• The string in the [b]'play()'[/b] method refers to name of the animation given in the SpriteFrame Editor."
	])
	complete_step()

	# Animation code - Part 2
	bubble_set_title("Add Idle Animation")
	bubble_add_text([
	   "Now we also need the to flip the sprite when we are walking to the left.",
	   "",
	   "To do this, place the following code under the if statement [code]if direction:[/code]:"
	])
	bubble_add_code([
"if velocity.x < 0:
	$AnimatedSprite2D.flip_h = true
else:
	$AnimatedSprite2D.flip_h = false"
	])
	bubble_add_text([
	   "",
	   "Our new code now flips the sprite when moving left and plays 'run' or 'idle' animations based on movement speed."
	])
	complete_step()

func section_05_world_creation() -> void:
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Creating the Game World")
	if FileAccess.file_exists("res://tours/plattformer-guide/assets/World/Terrain/Flatt_Plattform.png"):
		bubble_add_texture(preload("res://tours/plattformer-guide/assets/World/Terrain/Flatt_Plattform.png"), 300.0)
	bubble_add_text([
		"Now let's create a proper game world using Godot's tilemap system.",
		"",
		"Tilemaps are the standard way to build 2D levels because they:",
		"• Allow you to paint levels using reusable tile pieces",
		"• Automatically handle collision detection among other things",
		"• Let you reuse art assets across different areas"
	])
	complete_step()

	# Create main scene
	highlight_controls([interface.filesystem_tree, interface.main_screen_tabs])
	highlight_filesystem_paths(["platformer_game", "platformer_game/scenes"])
	bubble_move_and_anchor(interface.filesystem_dock, Bubble.At.TOP_RIGHT, 16.0, Vector2(550, 50))
	bubble_set_title("Create the Main Game Scene")
	bubble_add_text([
		"Let's create our main game scene that will contain the level, player, and game elements.",
		"",
		"Right-click on the 'scenes' folder and select '[b]Create New → Scene[/b]'.",
		"In the dialog, choose '2D Scene' and name it 'main'."
	])
	bubble_add_task(
		"Create a new scene called 'main' in the scenes folder",
		1,
		func(task: Task) -> int:
			return 1 if FileAccess.file_exists("res://platformer_game/scenes/main.tscn") else 0
	)
	complete_step()

	# Open the main scene
	scene_open("res://platformer_game/scenes/main.tscn")
	highlight_controls([interface.scene_dock])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title("Set Up the Level Structure")
	bubble_add_text([
		"Now we'll add the nodes needed for our level.",
		"",
		"Our scene structure will be:",
		"",
		"[code]Main (Node2D)[/code]",
		"[code]├── TileMapLayer[/code]",
		"[code]└── Player (instance)[/code]",
	])
	complete_step()

	# Add TileMapLayer
	highlight_scene_nodes_by_name(["Main"])
	bubble_set_title("Add TileMapLayer")
	bubble_add_text([
		"Add a [b]TileMapLayer[/b] node as a child of Main. Do not use the node [b]TileMap[/b] as it is deprecated.",
		"",
		"TileMapLayer is Godot's system for creating tile-based levels. It handles both the visual tiles and their collision shapes."
	])
	bubble_add_task(
		"Add [b]TileMapLayer[/b] as child of Main",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root and scene_root.name == "Main":
				return 1 if scene_root.find_child("TileMapLayer") != null else 0
			return 0
	)
	complete_step()

	# Setup TileSet resource
	highlight_scene_nodes_by_name(["TileMapLayer"])
	highlight_controls([interface.inspector_dock])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Create TileSet Resource")
	bubble_add_text([
		"Select the TileMapLayer and look in the Inspector.",
		"",
		"Find the '[b]Tile Set[/b]' property (it should show '<empty>').",
		"Click on it and choose '[b]New TileSet[/b]' to create a tileset resource."
	])
	bubble_add_task(
		"Create a new TileSet resource for the TileMapLayer",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var tilemap_layer = scene_root.find_child("TileMapLayer")
				if tilemap_layer != null:
					var tileset = tilemap_layer.get("tile_set")
					return 1 if tileset != null else 0
			return 0
	)
	complete_step()

	# Configure TileSet
	highlight_controls([interface.tileset])
	bubble_move_and_anchor(interface.tileset, Bubble.At.TOP_CENTER, 16 ,Vector2(0, -500))
	bubble_set_title("Configure Your TileSet")
	bubble_add_text([
		"The TileSet editor should now appear at the bottom of the screen.",
		"",
		"To set up your tileset click the '[b]+[/b]' button, then select '[b]Atlas[/b]'.",
		"There you can pick the image containing your tiles.",
		"",
		"In a pop-up you will be asked if tiles should be automatically selected. Pick yes, or select the tiles in for your tileset manually.",
	])
	complete_step()

	# Highlight the tileset tabs for navigation
	var tileset_tile_tabs = interface.tileset_tiles_panel.get_children()[1].get_children()[1].get_children()[0].get_children()[0]
	highlight_controls([tileset_tile_tabs])
	bubble_set_title("Navigate TileSet Tabs")
	bubble_add_text([
		"You'll see several tabs in the TileSet editor:",
		"",
		"• '[b]Setup[/b]' - Where you select which tiles to use",
		"• '[b]Select[/b]' - For choosing tiles to edit",
		"• '[b]Paint[/b]' - For painting tile properties",
		"",
		"Make sure you're on the '[b]Setup[/b]' tab and click on the tiles you want to use in your game (if this wasn't done automatically)."
	])
	complete_step()

	highlight_controls([interface.inspector_dock])
	bubble_set_title("Add Physics Layer")
	bubble_add_text([
		"Now we need to add collision shapes so your platforms are solid.",
		"",
		"1. In the Inspektor, find the '[b]Physics Layers[/b]' section in the properties of the the Tile Set",
		"2. Click '[b]Add Element[/b]' to create a physics layer",
		"",
		"This creates a collision layer that you can apply to your tiles."
	])
	complete_step()

	# Add physics to tiles with specific highlighting
	var tile_inspector = interface.tileset_tiles_panel.get_children()[1].get_children()[1].get_children()[0]
	var tile_canvas = interface.tileset_tiles_panel.get_children()[1].get_children()[1].get_children()[1]
	highlight_controls([tileset_tile_tabs.get_children()[1], tile_inspector, tile_canvas])
	bubble_set_title("Add Collisions")
	bubble_add_text([
		"3. Open the '[b]Select[/b]' tab in the TileSet editor.",
		"4. Click on one of your tiles in the TileSet panel to select it.",
		"",
		"You should see the tile highlighted, and options will appear on the left side."
	])
	complete_step()

	bubble_set_title("Configure Collision Shape")
	highlight_controls([tileset_tile_tabs.get_children()[1], tile_inspector, tile_canvas])
	bubble_add_text([
		"5. Navigate to '[b]Physics[/b]' → '[b]Physics Layer 0[/b]'",
		"6. You can either:",
		"   • Draw collision shapes manually by applying edges to define a collsion polygon",
		"   • Click '[b]Reset to default tile shape[/b]' for automatic collision in the burger menu to mark the full tile",
		"",
		"Repeat this for each tile type you want to be solid."
	])
	complete_step()

	# Use the tilemap
	context_set_2d()
	highlight_controls([interface.tilemap_tiles_panel, interface.bottom_button_tilemap, interface.canvas_item_editor])
	bubble_move_and_anchor(interface.tilemap, Bubble.At.TOP_CENTER, 16 ,Vector2(0, -500))
	bubble_set_title("Paint Your Level")
	bubble_add_text([
		"Now you can paint your level! The 'TileMap' panel appears when you select the TileMapLayer node.",
		"",
		"From the 'TileMap' panel you can:",
		"• Click on a tile to select it",
		"• Click in the 2D canvas to place tiles",
		"• Hold and drag to paint multiple tiles",
		"• Remove tiles with right-click"
	])
	#bubble_add_video(load("res://tours/plattformer-guide/assets/Videos/TileMap.mp4"))
	complete_step()
	
	# Create player scene from test scene
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_title("Create Player Scene")
	bubble_add_text([
		"Before we can use our player in the main scene, we need to save it as its own scene file.",
		"",
		"Let's move to the test_scene to find our player."
	])
	scene_open("res://platformer_game/scenes/test_scene.tscn")
	complete_step()

	# Save player as scene
	highlight_scene_nodes_by_name(["Player"])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title("Save Player as Scene")
	bubble_add_text([
		"Right-click on the '[b]Player[/b]' node in the scene tree.",
		"Select '[b]Save Branch as Scene[/b]' from the context menu.",
		"",
		"Save it as 'player.tscn' in the scenes folder.",
		"",
		"This creates a reusable player scene that we can use in any level."
	])
	bubble_add_task(
		"Save the Player node as 'player.tscn' in the scenes folder",
		1,
		func(task: Task) -> int:
			return 1 if FileAccess.file_exists("res://platformer_game/scenes/player.tscn") else 0
	)
	complete_step()

	# Now go back to main scene for the next step
	scene_open("res://platformer_game/scenes/main.tscn")

	# Add player to scene
	highlight_filesystem_paths(["platformer_game/scenes/player.tscn"])
	highlight_controls([interface.filesystem_dock, interface.scene_dock, interface.canvas_item_editor])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Add Player to Scene")
	bubble_add_text([
	   "Now let's add our player to the main scene.",
	   "Drag the player.tscn file from the FileSystem into either the scene tree or the canvas.",
	   "Position the player above your platforms."
	])
	mouse_move_by_callable(
	func() -> Vector2:
		var root = interface.filesystem_tree.get_root()
		if root:
			var items = Utils.filter_tree_items(root, func(item: TreeItem) -> bool:
				return item.get_text(0) == "player.tscn"
			)
			if items.size() > 0:
				var rect = interface.filesystem_tree.get_global_transform() * interface.filesystem_tree.get_item_area_rect(items[0], 0)
				return rect.get_center()
		return interface.filesystem_dock.global_position + Vector2(100, 100),
	   get_control_global_center.bind(interface.canvas_item_editor)
	)
	bubble_add_task(
	   "Instance the player scene in the main scene",
	   1,
		func(task: Task) -> int:
		var scene_root = EditorInterface.get_edited_scene_root()
		if scene_root and scene_root.name == "Main":
			return 1 if scene_root.find_child("Player") != null else 0
		return 0
	)
	complete_step()

	# Add background
	highlight_scene_nodes_by_name(["Main"])
	highlight_controls([interface.scene_dock])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title("Add a Scrolling Background")
	bubble_add_text([
		"Let's add a parallax background to give our level more depth and visual appeal.",
		"",
		"Parallax backgrounds move at different speeds than the foreground, creating an illusion of depth. It also allows us to repeat our background image.",
		"",
		"Add a [b]Parallax2D[/b] node as a child of Main.",
	])
	bubble_add_task(
	   "Add Parallax2D as child of Main",
	   1,
	func(task: Task) -> int:
		var scene_root = EditorInterface.get_edited_scene_root()
		if scene_root and scene_root.name == "Main":
			return 1 if scene_root.find_child("Parallax2D") != null else 0
		return 0
	)
	complete_step()

	# Add Sprite2D to Parallax2D
	highlight_scene_nodes_by_name(["Parallax2D"])
	bubble_set_title("Add Background Sprite")
	bubble_add_text([
	   "Add a [b]Sprite2D[/b] node as a child of the Parallax2D.",
	   "",
	   "This Sprite2D will display your background image and automatically scroll at a different speed than the camera."
	])
	bubble_add_task(
	   "Add Sprite2D as child of Parallax2D",
	   1,
	func(task: Task) -> int:
		var scene_root = EditorInterface.get_edited_scene_root()
		if scene_root:
			var parallax_node = scene_root.find_child("Parallax2D")
			if parallax_node != null:
				return 1 if parallax_node.find_child("Sprite2D") != null else 0
		return 0
	)
	complete_step()

	# Configure the background texture
	highlight_scene_nodes_by_name(["Sprite2D"])
	highlight_controls([interface.inspector_dock])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Add Background Texture")
	bubble_add_text([
	   "Select the Sprite2D node under Parallax2D and assign a background texture.",
	   "",
	   "In the Inspector, find the '[b]Texture[/b]' property and load a background image.",
	   "",
	   "Choose an image that's wider than your screen so it can scroll smoothly."
	])
	bubble_add_task(
	   "Add a texture to the background Sprite2D",
	   1,
	func(task: Task) -> int:
		var scene_root = EditorInterface.get_edited_scene_root()
		if scene_root:
			var parallax_node = scene_root.find_child("Parallax2D")
			if parallax_node:
				var sprite_node = parallax_node.find_child("Sprite2D")
				if sprite_node != null:
					var texture = sprite_node.get("texture")
					return 1 if texture != null else 0
		return 0
	)
	complete_step()

	# Configure parallax settings
	highlight_scene_nodes_by_name(["Parallax2D"])
	highlight_controls([interface.inspector_dock])
	bubble_set_title("Configure Parallax Settings")
	bubble_add_text([
		"Select the Parallax2D node and configure its scrolling behavior.",
		"",
		"In the Inspector, you'll find these key properties:",
		"• '[b]Scroll Scale[/b]' - Controls how fast the background moves (try 0.5 for half speed) but keep the 1.0 for the y-axis",
		"• '[b]Repeat Size[/b]' - Set this to your background image's width for seamless tiling",
		"• '[b]Repeat Times[/b]' - This is the amount of times the image gets repeated. Pick a value high enough to cover your level",
		"• '[b]Autoscroll[/b]' - The speed at which the image moves on its own. Not relevant for the basic background",
		"", 
		"Experiment with different Scroll Scale values to get the effect you like! For a background image "
	])
	complete_step()

	# Position the background
	context_set_2d()
	highlight_scene_nodes_by_name(["Parallax2D"])
	highlight_controls([interface.canvas_item_editor, interface.inspector_dock])
	bubble_set_title("Position Your Background")
	bubble_add_text([
	   "Use the 2D viewport to position your background properly.",
	   "",
	   "Make sure the background covers the area where your player will move. You can:",
	   "• Move the Parallax2D node to adjust the starting position",
	   "• Scale the Parallax2D if needed to cover more area in the inspector",
	   "",
	   "The background will automatically scroll as the camera follows your player!"
	])
	complete_step()

	# Test the parallax effect
	highlight_controls([interface.run_bar_play_button])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Test the Parallax Effect")
	bubble_add_text([
	   "Test your game to see the parallax background in action!",
	   "",
	   "The background should be repeating. As your player moves around, the background should be repeating.",
	])
	bubble_add_task_press_button(interface.run_bar_play_button)
	complete_step()

	# Test the parallax effect
	highlight_controls([interface.run_bar_play_button])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Test the background")
	bubble_add_text([
	   "For a real parallax effect, you'll want multiple background layers moving at different speeds.",
	   "",
	   "Real parallax backgrounds typically have:",
	   "• [b]Far background[/b] - Mountains, sky (very slow, like 0.1-0.3 scroll scale)",
	   "• [b]Middle background[/b] - Trees, buildings (medium speed, like 0.4-0.6 scroll scale)", 
	   "• [b]Near background[/b] - Foreground details (faster, like 0.7-0.9 scroll scale)",
	   "",
	   "Try adding a second Parallax2D node with a different Scroll Scale value to see the layered effect!"
	])
	bubble_add_task(
		"Add a second Parallax2D node to create multiple background layers",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root and scene_root.name == "Main":
				var parallax_nodes = scene_root.find_children("*", "Parallax2D", false, false)
				return 1 if parallax_nodes.size() >= 2 else 0
			return 0
	)
	complete_step()

	# Save main scene
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.TOP_CENTER)
	bubble_set_title("Save Main Scene")
	bubble_add_text([
		"Save your main scene as '[b]main.tscn[/b]' in the scenes folder.",
		"This will be the main scene of your game."
	])
	bubble_add_task(
		"Save the scene as 'main.tscn' in the scenes folder",
		1,
		func(task: Task) -> int:
			return 1 if FileAccess.file_exists("res://platformer_game/scenes/main.tscn") else 0
	)
	complete_step()

func section_06_collectables() -> void:
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Adding Collectables and Scoring")
	if FileAccess.file_exists("res://tours/plattformer-guide/assets/Points/Crystal/01.png"):
		bubble_add_texture(preload("res://tours/plattformer-guide/assets/Points/Crystal/big_crystal.png"), 300.0)
	bubble_add_text([
		"Let's add collectables to give our game some sort of goal!",
		"",
		"We'll create:",
		"• Collectable items (coins)",
		"• A scoring system that tracks collected items",
		"• UI to display the score to the player",
	])
	complete_step()

	# Create collectable scene
	highlight_controls([interface.filesystem_tree, interface.main_screen_tabs])
	highlight_filesystem_paths(["platformer_game", "platformer_game/scenes"])
	bubble_move_and_anchor(interface.filesystem_dock, Bubble.At.TOP_RIGHT, 16.0, Vector2(550, 50))
	bubble_set_title("Create Collectable Scene")
	bubble_add_text([
		"First, let's create a new scene for our collectable items.",
		"",
		"Right-click on the 'scenes' folder in the FileSystem and select '[b]Create New → Scene[/b]'.",
		"In the dialog, choose 'Area2D' and name it 'collectable'.",
		"",
		"Area2D is perfect for our collectables because it can detect when the player touches it without collision."
	])
	bubble_add_task(
		"Create a new scene called 'collectable' in the scenes folder",
		1,
		func(task: Task) -> int:
			return 1 if FileAccess.file_exists("res://platformer_game/scenes/collectable.tscn") else 0
	)
	complete_step()

	# Add child nodes to collectable
	highlight_scene_nodes_by_name(["Area2D"])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title("Add Child Nodes")
	bubble_add_text([
		"Now add these child nodes to your Area2D:",
		"",
		"• [b]CollisionShape2D[/b] - For the trigger area that detects the player",
		"• [b]AnimatedSprite2D[/b] - For the visual appearance and animations",
		"",
		"Right-click on the Area2D and select 'Add Child' to add each of these."
	])
	bubble_add_task(
		"Add [b]CollisionShape2D[/b] and [b]AnimatedSprite2D[/b] as children of Area2D",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root and scene_root.name == "Collectable":
				var has_collision = scene_root.find_child("CollisionShape2D") != null
				var has_sprite = scene_root.find_child("AnimatedSprite2D") != null
				return 1 if has_collision and has_sprite else 0
			return 0
	)
	complete_step()
	
	# Setup AnimatedSprite2D
	var spriteframes_editor = interface.logger.get_parent().get_parent().get_children()[0].get_children()[9]
	highlight_scene_nodes_by_name(["AnimatedSprite2D"])
	highlight_controls([interface.inspector_dock, spriteframes_editor, interface.filesystem_dock])
	bubble_set_title("Add Collectable Animation")
	bubble_add_text([
		"Select the AnimatedSprite2D node and set up its animations.",
		"",
		"1. In the Inspector, create a '[b]New SpriteFrames[/b]' resource",
		"2. Click on it to open the SpriteFrames editor",
		"3. Add your collectable frames to create a simple animation",
		"4. Enable looping %s for a continuous animation effect" % bbcode_generate_icon_image_string(ICONS_MAP.loop),
		"5. Enable autoplay on load %s so the animations starts by itself" % bbcode_generate_icon_image_string(ICONS_MAP.autoplay),
	])
	bubble_add_task(
		"Create SpriteFrames and add animation frames for the collectable",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var sprite = scene_root.find_child("AnimatedSprite2D")
				if sprite != null:
					var sprite_frames = sprite.get("sprite_frames")
					if sprite_frames != null and sprite_frames.has_animation("default"):
						return 1 if sprite_frames.get_frame_count("default") > 0 else 0
			return 0
	)
	complete_step()

	# Setup collision shape
	context_set_2d()
	highlight_scene_nodes_by_name(["CollisionShape2D"])
	highlight_controls([interface.inspector_dock])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Configure Collision Shape")
	bubble_add_text([
		"Select the CollisionShape2D node and set up its shape.",
		"",
		"In the Inspector, find the '[b]Shape[/b]' property and create a '[b]New RectangleShape2D[/b]' or '[b]New CircleShape2D[/b]'.",
		"",
		"Size it to match your collectable sprite."
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

	# Add collectable script
	highlight_scene_nodes_by_name(["Collectable", "Area2D"])
	highlight_controls([interface.scene_dock.get_children()[0].get_children()[3]])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title("Add Collectable Script")
	bubble_add_text([
		"Now we need to add a script to handle the collection logic.",
		"",
		"Right-click on the [b]Area2D[/b] node and select '[b]Attach Script[/b]' %s." % bbcode_generate_icon_image_string(ICONS_MAP.script),
		"Save the script as 'collectable.gd' in the scripts folder."
	])
	bubble_add_task(
		"Attach a script to the Area2D node and save it as 'collectable.gd'",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				if scene_root.name == "Collectable" or scene_root.name == "Area2D":
					return 1 if scene_root.get_script() != null else 0
			return 0
	)
	complete_step()

	# Show collectable code
	context_set_script()
	queue_command(func():
		var script_path = "res://platformer_game/scripts/collectable.gd"
		if FileAccess.file_exists(script_path):
			var script_resource = load(script_path)
			EditorInterface.edit_resource(script_resource)
	)
	highlight_controls([interface.script_editor_code_panel])
	bubble_move_and_anchor(interface.script_editor_code_panel, Bubble.At.TOP_RIGHT)
	bubble_set_title("Collectable Script Code")
	bubble_add_text([
		"Replace the default script with this collectable logic:",
		""
	])
	bubble_add_code([
"extends Area2D

signal collected

@onready var player: Player
@export var score: int = 1

func _ready():
	player = get_tree().current_scene.get_node(\"Player\")
	body_entered.connect(_on_body_entered)
	collected.connect(player.add_score)
	$AnimatedSprite2D.play()

func _on_body_entered(body):
	if body is Player:
		emit_signal(\"collected\", score)
		queue_free()"
	])
	complete_step()

	# Explain the code
	bubble_set_title("Understanding the Code")
	bubble_add_text([
		"Let's break down the key parts:",
		"",
		"[b]@export var score: int = 1[/b] - Makes score editable in Inspector",
		"[b]signal collected[/b] - Declares a signal for when the item is collected",
		"[b]body_entered.connect()[/b] - Connects to Area2D's collision detection",
		"[b]emit_signal()[/b] - Sends the score value to the player",
		"[b]queue_free()[/b] - Safely removes the collectable from the scene"
	])
	complete_step()

	# Save collectable scene
	bubble_set_title("Save Collectable Scene")
	bubble_add_text([
		"Save your collectable scene with [b]Ctrl+S[/b].",
		"Make sure it's saved as 'collectable.tscn' in the scenes folder."
	])
	bubble_add_task(
		"Save the collectable scene",
		1,
		func(task: Task) -> int:
			return 1 if FileAccess.file_exists("res://platformer_game/scenes/collectable.tscn") else 0
	)
	complete_step()
	
		# Add UI to player scene
	context_set_2d()
	scene_open("res://platformer_game/scenes/player.tscn")
	highlight_controls([interface.scene_dock])
	bubble_move_and_anchor(interface.scene_dock, Bubble.At.TOP_LEFT, 16.0, Vector2(300, 50))
	bubble_set_title("Add Score UI to Player")
	bubble_add_text([
		"Now we need to add UI elements to display the score.",
		"",
		"Open the player scene and add these nodes to the Player:",
		"",
		"1. [b]CanvasLayer[/b] - Keeps UI fixed on screen regardless of camera movement",
		"2. [b]Label[/b] as child of CanvasLayer - Displays the score text"
	])
	bubble_add_task(
		"Add CanvasLayer and Label nodes to the Player for score display",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var player_node = scene_root.find_child("Player")
				if scene_root.name == "Player": player_node = scene_root
				if player_node:
					var canvas_layer = player_node.find_child("CanvasLayer")
					if canvas_layer != null:
						var label = canvas_layer.find_child("Label")
						return 1 if label != null else 0
			return 0
	)
	complete_step()

	# Configure the UI
	highlight_scene_nodes_by_name(["Label"])
	highlight_controls([interface.inspector_dock])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Configure Score Display")
	bubble_add_text([
		"Select the Label node and configure it:",
		"",
		"1. Set the '[b]Text[/b]' property to '0' (starting score)",
		"2. Position it in the top-left corner of the screen",
		"3. Increase the font size in '[b]Theme Overrides → Font Sizes → Font Size[/b]' if it is too small",
		"4. Consider adding a contrasting color or outline for readability",
		"",
		"When you are done save the updated player scene with [b]Ctrl+S[/b]."
	])
	bubble_add_task(
		"Configure the Label with initial text '0' and position it on screen",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root:
				var player_node = scene_root.find_child("Player")
				if scene_root.name == "Player": player_node = scene_root
				if player_node:
					var canvas_layer = player_node.find_child("CanvasLayer")
					if canvas_layer:
						var label = canvas_layer.find_child("Label")
						if label != null:
							var text = label.get("text")
							return 1 if text == "0" else 0
			return 0
	)
	complete_step()

	# Update player script for scoring
	bubble_move_and_anchor(interface.script_editor_code_panel, Bubble.At.CENTER)
	bubble_set_title("Update Player Script for Scoring")
	bubble_add_text([
		"Now we need to update the player script to handle scoring.",
		"",
		"Open the player.gd script. We need to add a score system."
	])
	queue_command(func():
		var script_path = "res://platformer_game/scripts/player.gd"
		if FileAccess.file_exists(script_path):
			var script_resource = load(script_path)
			EditorInterface.edit_resource(script_resource)
	)
	complete_step()

	# Show player code additions
	highlight_controls([interface.script_editor_code_panel])
	bubble_set_title("Add Scoring System to Player")
	bubble_add_text([
		"Add these lines to your player script:",
		""
	])
	bubble_add_code([
		"var score = 0",
"func add_score(amount):
	score += amount
	$CanvasLayer/Label.text = str(score)"
	])
	bubble_add_text([
		"",
		"[b]var score = 0[/b] - Tracks the player's current score",
		"[b]add_score()[/b] - Function called by collectables to increase score",
		"[b]$CanvasLayer/Label[/b] - Accesses the label by following its path in the node tree"
	])
	complete_step()

	# Add collectables to main scene
	context_set_2d()
	scene_open("res://platformer_game/scenes/main.tscn")
	highlight_controls([interface.filesystem_dock, interface.scene_dock, interface.canvas_item_editor])
	highlight_filesystem_paths(["platformer_game/scenes/collectable.tscn"])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Add Collectables to Level")
	bubble_add_text([
		"Now let's add some collectables to our main scene!",
		"",
		"Drag the '[b]collectable.tscn[/b]' file from the FileSystem into your level.",
		"Place several collectables around your platforms for players to find.",
		"",
		"Try placing them in interesting locations that require jumping or exploration to reach."
	])
	mouse_move_by_callable(
		func() -> Vector2:
			var root = interface.filesystem_tree.get_root()
			if root:
				var items = Utils.filter_tree_items(root, func(item: TreeItem) -> bool:
					return item.get_text(0) == "collectable.tscn"
				)
				if items.size() > 0:
					var rect = interface.filesystem_tree.get_global_transform() * interface.filesystem_tree.get_item_area_rect(items[0], 0)
					return rect.get_center()
			return interface.filesystem_dock.global_position + Vector2(100, 100),
		get_control_global_center.bind(interface.canvas_item_editor)
	)
	bubble_add_task(
		"Add at least one collectable instance to the main scene",
		1,
		func(task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root and scene_root.name == "Main":
				var collectables = scene_root.find_children("*", "Area2D", true, false)
				return 1 if collectables.size() > 0 else 0
			return 0
	)
	complete_step()

	# Optional: Customize collectable values
	highlight_scene_nodes_by_name(["Collectable", "Collectable2", "Collectable3", "Collectable4", "Collectable5", "Collectable6"])
	highlight_controls([interface.inspector_dock])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Customize Collectable Values")
	bubble_add_text([
		"You can customize each collectable's point value!",
		"",
		"Select a collectable instance in your scene and look for the '[b]Score[/b]' property in the Inspector.",
		"",
		"Try setting different values",
	])
	complete_step()

	# Test the scoring system
	highlight_controls([interface.run_bar_play_button])
	bubble_move_and_anchor(interface.inspector_dock, Bubble.At.TOP_LEFT, 16, Vector2(-550, 0))
	bubble_set_title("Test the Scoring System")
	bubble_add_text([
		"Time to test our collectable system!",
		"",
		"Run the game and try collecting the items.",
		"You should see:",
		"• The score increase when you touch a collectable",
		"• The collectable disappear when collected",
		"• The score display update in real-time"
	])
	bubble_add_task_press_button(interface.run_bar_play_button)
	complete_step()



func section_07_conclusion() -> void:
	bubble_move_and_anchor(interface.canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title("Congratulations!")
	bubble_add_text([
		bbcode_wrap_font_size("[center][b]You've Built Your First 2D Platformer![/b][/center]", 28),
		"",
		"[center]You've successfully created:[/center]",
		"• [color=green][b]A controllable player character[/b][/color] with movement and jumping",
		"• [color=purple][b]A tilemap-based game world[/b][/color] with platforms and collisions",
		"• [color=yellow][b]A collectable system[/b][/color] with scoring and UI",
	])
	complete_step()

	# Resource recommendations
	bubble_set_title("Learning Resources")
	bubble_add_text([
		"To continue your game development journey:",
		"",
		"[b]Official Documentation:[/b]",
		"• [url=https://docs.godotengine.org]Godot Documentation[/url]",
		"• [url=https://docs.godotengine.org/en/stable/tutorials/2d/2d_sprite_animation.html]2D Animation Guide[/url]",
		"",
		"[b]Community Resources:[/b]",
		"• [url=https://godotengine.org/community]Godot Community[/url]",
		"• [url=https://www.youtube.com/c/GDQuest]GDQuest YouTube Channel[/url]",
		"• [url=https://kidscancode.org/godot_recipes/]Godot Recipes[/url]",
	])
	complete_step()

	# Final congratulations
	if BUBBLE_BACKGROUND:
		bubble_set_background(BUBBLE_BACKGROUND)
	queue_command(func set_avatar_happy() -> void:
		# If you have avatar expressions, set to happy
		pass
	)
	bubble_set_title("")
	bubble_add_text([
		bbcode_wrap_font_size("[center][b]🎉 Tutorial Complete! 🎉[/b][/center]", 32),
		"",
		"[center]You now have a solid foundation in 2D platformer development![/center]",
		"[center]Share your creation with friends and keep building amazing games.[/center]",
		"",
		"[center][b]Happy Game Development![/b][/center]"
	])
	bubble_set_footer(CREDITS_FOOTER)
	complete_step()
