extends Node

@export var initial_bgm: AudioStream
@export var sfx_placeholder: AudioStream
@export var sfx_library: Dictionary[String, AudioStream]

var background_music: AudioStreamPlayer

var background_volume := 1.0
var sfx_volume := 1.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if initial_bgm:
		play_background_music(initial_bgm)

func play_background_music(stream: AudioStream, volume: float = 0.0) -> void:
	if not stream:
		return
	
	if background_music:
		if stream == background_music.stream:
			return
			
		background_music.queue_free()
		
	var stream_player = _create_stream_player(stream)
	stream_player.volume_db = volume + background_volume
	stream_player.play()
	background_music = stream_player

func play_sfx(sfx_name: String, volume: float = 0.0) -> AudioStreamPlayer:
	var audio_stream: AudioStream = sfx_placeholder
	if sfx_library.get(sfx_name):
		audio_stream = sfx_library.get(sfx_name)
		
	var stream_player = _create_stream_player(audio_stream)
	stream_player.volume_db = volume + sfx_volume
	stream_player.play()
	return stream_player

func play_sfx_with_random_pitch(sfx_name: String, volume: float = 0.0, min: float = 0.9, max: float = 1.1) -> AudioStreamPlayer:
	var audio_stream: AudioStream = sfx_placeholder
	if sfx_library.get(sfx_name):
		audio_stream = sfx_library.get(sfx_name)
		
	var stream_player = _create_stream_player(audio_stream)
	stream_player.volume_db = volume + sfx_volume
	stream_player.pitch_scale = randf_range(min, max)
	stream_player.play()
	return stream_player

func set_background_volume(value: float) -> void:
	var volume = remap(value, 0, 100, -30, 1)
	background_volume = volume
	if background_music:
		background_music.volume_db = background_volume

func set_sfx_volume(value: float) -> void:
	var volume = remap(value, 0, 100, -30, 1)
	sfx_volume = volume

func stop_sfx(stream_player: AudioStreamPlayer) -> void:
	stream_player.stop()
	stream_player.queue_free()
	
func _create_stream_player(stream: AudioStream) -> AudioStreamPlayer:
	var stream_player = AudioStreamPlayer.new()
	stream_player.stream = stream
	stream_player.finished.connect(stream_player.queue_free)
	add_child(stream_player)
	return stream_player
