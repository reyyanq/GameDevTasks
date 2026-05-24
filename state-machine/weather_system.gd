extends Node2D

# states
enum WeatherState {SUNNY, RAINY, CLOUDY}

var current_state: WeatherState = WeatherState.SUNNY

# Onready references to visual components
@onready var background: ColorRect = $CanvasLayer/Background
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout) # connecting the timer timeout signal to transition function
	apply_state_behavior() # Initialize the first state's visuals

# Handling the behavior and visuals for each state
func apply_state_behavior() -> void:
	match current_state:
		WeatherState.SUNNY:
			print("--- [STATE: SUNNY] It's a sunny day! ---")
			background.color = Color("SkyBlue") 
			
		WeatherState.CLOUDY:
			print("--- [STATE: CLOUDY] well.. There are clouds! ---")
			background.color = Color("Linen") 
			
		WeatherState.RAINY:
			print("--- [STATE: RAINY] It's starting to rain... ---")
			background.color = Color("Dark Gray") 

# Transitions triggered by the timer
func _on_timer_timeout() -> void:
	var random_choice = randf() # a float 0.0 - 1.0
	
	match current_state:
		WeatherState.SUNNY:
			# 100% chance to go to Cloudy next
			current_state = WeatherState.CLOUDY
			
		WeatherState.CLOUDY:
			# 50% chance to clear up, 50% chance to a rain
			if random_choice < 0.5:
				current_state = WeatherState.SUNNY
			else:
				current_state = WeatherState.RAINY
				
		WeatherState.RAINY:
			# After rain the weather turns cloudy
			current_state = WeatherState.CLOUDY
	
	# Applying the new state's visuals and console prints
	apply_state_behavior()
	
	
