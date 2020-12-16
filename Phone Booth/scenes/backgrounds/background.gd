extends Control
export(VideoStreamTheora) var video_stream
export(StreamTexture) var palette
export(bool) var loop = true

func _ready():
	set_palette(palette)
	set_video(video_stream)
	$VideoPlayer.play()
	
func _on_VideoPlayer_finished():
	if loop: 
		$VideoPlayer.play()

func set_video(new_video): 
	video_stream = new_video
	$VideoPlayer.stream = video_stream

func set_palette(new_palette): 
	palette = new_palette
	$VideoPlayer.material.set_shader_param("palette",palette)
