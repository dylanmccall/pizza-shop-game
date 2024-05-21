extends PanelContainer

@onready var countdown = $Box/Countdown
@onready var message = $Box/Message
@onready var timer = $Timer
@export var game_time: int = 60

signal start_pressed
signal ready_pressed
signal countdown_timeout

func start_countdown():
	timer.start(game_time)
	timer.paused = false

func set_message(msg:String):
	message.text = msg

func _update_countdown():
	countdown.text = str(ceil(timer.time_left))

func _process(_delta):
	_update_countdown()

func _on_timer_timeout():
	countdown_timeout.emit()

func _on_start_pressed():
	_update_countdown()
	start_pressed.emit()


func _on_ready_pressed():
	timer.paused = true
	ready_pressed.emit()
