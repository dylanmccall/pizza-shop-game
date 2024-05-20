extends Panel

@onready var label = $Box/Countdown
@onready var timer = $Timer
signal timeout

func start(time: int):
	timer.start(time)
	_update_label()

func _update_label():
	label.text = str(ceil(timer.time_left))

func _process(_delta):
	_update_label()

func _on_timer_timeout():
	print("It's all over now")
	timeout.emit()
