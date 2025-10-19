extends Control

@onready var special_cooldown_bar = $SpecialBar
@onready var synergy_meter = $SynergyBar

# Player special attack tracking - BARE MINIMUM
var was_special_available: bool = true

func _ready():
    await get_tree().process_frame  # Wait for game to initialize
    _connect_to_current_player()

func _connect_to_current_player():
    var current_player = GameManager.curr_player
    if current_player and current_player.state_machine:
        # Connect to state machine signals
        var state_machine = current_player.state_machine
        if not state_machine.state_entered.is_connected(_on_player_state_changed):
            state_machine.state_entedsed.connect(_on_player_state_changed)
            print("Connected to state machine for: ", current_player.name)

func _on_player_state_changed(state_name: String):
    print("Player entered state: ", state_name)
    match state_name:
        PlayerState.ATTACKING_SPECIAL:
            start_special_cooldown()
        PlayerState.ATTACKING_CHARGED_SPECIAL: 
            start_special_cooldown()
        PlayerState.CHARGING_SPECIAL:
            # Could show charging indicator
            pass
# TODO, give it animation
func start_special_cooldown():
    var current_player = GameManager.curr_player
    if current_player:
        special_cooldown_bar.value = 0  # Start empty
        # Connect to the timer that gets created in the exit() function
        await get_tree().create_timer(current_player.special_cd).timeout
        special_cooldown_bar.value = 100  # Back to full