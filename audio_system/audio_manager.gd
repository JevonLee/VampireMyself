extends Node
## Autoload
	
## 音频资源的总线类型
enum Bus{
	MASTER,
	MUSIC,
	SFX,
}

## 对应总线的名称
const MUSIC_BUS = "Music"
const SFX_BUS = "SFX"

##音乐播放器的个数,默认是2，两个播放器可以实现渐变的效果
var music_player_count:int = 2
## 当前音乐播放器的下标，默认是0
var current_music_player_index:int = 0
##音乐播放器存放的数组
var music_players:Array[AudioStreamPlayer]
##音乐渐变时长
var music_fade_duration:float = 1.0

##音效播放器的个数，随便的6个，意味着同时最多可以播放6个音效
var sfx_player_count:int = 6
##音效播放器存放的数组
var sfx_players:Array[AudioStreamPlayer]
##当前音效播放器的下标
var current_sfx_player_index:int = 0


func _ready() -> void:
	initial_music_player()
	initial_sfx_player()


## 初始化音乐播放器
func initial_music_player() -> void:
	for i in music_player_count:
		var audio_player := AudioStreamPlayer.new()
		audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
		audio_player.bus = MUSIC_BUS
		add_child(audio_player)
		music_players.append(audio_player)
	
	
## 初始化音效播放器
func initial_sfx_player() -> void:
	for i in sfx_player_count:
		var sfx_player := AudioStreamPlayer.new()
		sfx_player.bus = SFX_BUS
		add_child(sfx_player)
		sfx_players.append(sfx_player)
		
		
## 播放音乐函数,音乐同一时间只能播放一首
func play_music(audio:AudioStream) -> void:
	var current_audio_player := music_players[current_music_player_index]
	if current_audio_player.stream == audio:
		return##避免相同的音乐重复播放
	var empty_audio_player_index = 0 if current_music_player_index == 1 else 1
	var empty_audio_player = music_players[empty_audio_player_index] 
	empty_audio_player.stream = audio
	play_fade_in(empty_audio_player)
	play_fade_out(current_audio_player)
	current_music_player_index = empty_audio_player_index
	
	
##停止当前音乐播放
func stop_music() -> void:
	var current_audio_player := music_players[current_music_player_index]
	play_fade_out(current_audio_player)
	
	
## 渐入
func play_fade_in(audio_player:AudioStreamPlayer) -> void:
	audio_player.play()
	var tween = create_tween()
	tween.tween_property(audio_player,"volume_db",0,music_fade_duration)
	
	
## 渐出
func play_fade_out(audio_player:AudioStreamPlayer) -> void:
	var tween = create_tween()
	tween.tween_property(audio_player,"volume_db",-40,music_fade_duration)
	await tween.finished
	audio_player.stop()
	audio_player.stream = null
	
	
##设置音量大小，第一个参数是枚举类型Bus{Master,Music,sfx}
func set_volume(bus_index:Bus,v:float) -> void:
	var db = linear_to_db(v) #这里的
	AudioServer.set_bus_volume_db(bus_index,db)


	
## 播放音效函数，音效可以同时播放多个，相同的音效同时只能播放一个，泰拉好像僵尸之类的没有脚步声
func play_sfx(audio:AudioStream) -> void:
	#提前遍历一遍，先找所有播放器是否已经有audio，防止播放同一个音效
	for i in sfx_player_count:
		var sfx_player = sfx_players[i] as AudioStreamPlayer
		if sfx_player.stream == audio:
			if sfx_player.playing:
				return
			else:
				sfx_player.play()
				return
			##WARNING:逻辑上没问题，但是因为音效原因，反复播放听起来还是很奇怪，
			##泰拉中怪物走路没有声音，打击怪物的时候会频繁播放一个声音，这个音效很清脆很爽
			##所以应适当选择音效播放
			
	#没有找到相同的才播放audio音效
	for i in sfx_player_count:
		var sfx_player = sfx_players[i] as AudioStreamPlayer
		if not sfx_player.playing: 
			sfx_player.stream = audio
			sfx_player.play()
			break


	
##从音频数组中播放随机音效，WARNING：慎用，对于相似的音效，不是同一个资源，但是声音会叠加
func play_random_sfx(audios:Array[AudioStream]) -> void:
	var audio = audios.pick_random()
	
	for i in sfx_player_count:
		var sfx_player = sfx_players[i] as AudioStreamPlayer
		if sfx_player.stream == audio:
			if sfx_player.playing:
				return
			else:
				sfx_player.play()
				return
			
			
	#没有找到相同的才播放audio音效
	for i in sfx_player_count:
		var sfx_player = sfx_players[i] as AudioStreamPlayer
		if not sfx_player.playing: 
			sfx_player.stream = audio
			sfx_player.play()
			break
