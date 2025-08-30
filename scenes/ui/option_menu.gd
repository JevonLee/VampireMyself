extends CanvasLayer
class_name OptionMenu

@onready var sfx_slider: HSlider = %SfxSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var window_button: Button = %WindowButton
@onready var back_button: Button = %BackButton
@onready var play_music: Button = %PlayMusic

signal back_pressed

@export var test_sfx:AudioStream
@export var test_music:AudioStream

func _ready() -> void:
	window_button.pressed.connect(on_window_button_pressed)
	sfx_slider.value_changed.connect(on_sfx_changed)
	music_slider.value_changed.connect(on_music_changed)
	play_music.pressed.connect(on_play_music_pressed)
	back_button.pressed.connect(on_back_button_pressed)
	update_display()
	
	
	
func update_display() -> void:
	var mode = DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Window"
	elif mode == DisplayServer.WINDOW_MODE_WINDOWED:
		window_button.text = "Full Screen"
	sfx_slider.value = get_bus_volumn_percent("SFX")
	music_slider.value = get_bus_volumn_percent("Music")
	
	
func get_bus_volumn_percent(bus_name:String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volumn_db = AudioServer.get_bus_volume_db(bus_index) #返回音量
	return db_to_linear(volumn_db)
	
	
func set_bus_volumn_percent(bus_name:String,percent:float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volumn_db =  linear_to_db(percent) #返回音量
	AudioServer.set_bus_volume_db(bus_index,volumn_db)

	
func on_window_button_pressed() -> void:
	##设置窗口模式需要将运行窗口设置为非嵌入式窗口
	var mode = DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif mode == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
	update_display()


func on_sfx_changed(value:float) -> void:
	set_bus_volumn_percent("SFX",value)
	AudioManager.play_sfx(test_sfx)
	
	
func on_music_changed(value:float) -> void:
	set_bus_volumn_percent("Music",value)

var count = 0
func on_play_music_pressed() -> void:
	if count % 2 ==0:
		play_music.text = "StopMusic"
		AudioManager.play_music(test_music)
	else:
		play_music.text = "TestMusic"
		AudioManager.stop_music()
	count+=1
	
	
func on_back_button_pressed() -> void:
	AudioManager.stop_music()
	back_pressed.emit()
