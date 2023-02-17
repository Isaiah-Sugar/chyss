extends Node

var sfx_player = AudioStreamPlayer.new()

const atonal_folder = "res://sfx/atonal/atonal-"
const num_atonal = 10
var atonal_streams = []
const tonal_folder = "res://sfx/tonal/tonal-"
const num_tonal = 21
var tonal_streams = []
const badunk_folder = "res://sfx/badunk/badunk-"
const num_badunk = 16
var badunk_streams = []

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(sfx_player)
	sfx_player.volume_db = -10
	atonal_streams = generate_streams(atonal_folder, num_atonal)
	tonal_streams = generate_streams(tonal_folder, num_tonal)
	badunk_streams = generate_streams(badunk_folder, num_badunk)


func play_atonal(intensity: float) -> void:
	sfx_player.stop()
	sfx_player.stream = atonal_streams[intensity_to_index(intensity, num_atonal)]
	sfx_player.play()

func play_tonal(intensity: float) -> void:
	sfx_player.stop()
	sfx_player.stream = tonal_streams[intensity_to_index(intensity, num_tonal)]
	sfx_player.play()

func play_badunk(intensity: float) -> void:
	sfx_player.stop()
	sfx_player.stream = badunk_streams[intensity_to_index(intensity, num_badunk)]
	sfx_player.play()


func intensity_to_index(intensity, num_samples):
	return (int(intensity * num_samples))

func generate_streams(folder, num_samples):
	var stream_array = []
	for i in range(1,num_samples+1):
		print("generate stream for sample "+str(i))
		
		stream_array.append(load_to_stream(folder + str(i) +".wav"))
	return stream_array

func load_to_stream(path: String):
	var file = File.new()
	var stream = AudioStreamSample.new()
	if file.file_exists(path):
		file.open(path, file.READ)    
		stream.data = file.get_buffer(file.get_len())
		stream.format = AudioStreamSample.FORMAT_16_BITS  
		stream.stereo = true
		file.close()
	else:
		print("file does not exist: " + path)
	return stream
