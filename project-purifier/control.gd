extends Control

@onready var popinf: Label = $"Cool Border/InfoPanel/popinf"
@onready var warinf: Label = $"Cool Border/InfoPanel/warinf"
@onready var purinf: Label = $"Cool Border/InfoPanel/purinf"
@onready var resinf: Label = $"Cool Border/InfoPanel/resinf"
@onready var wilinf: Label = $"Cool Border/InfoPanel/wilinf"
@onready var soulinf: Label = $"Cool Border/InfoPanel/soulinf"
@onready var planinf: Label = $"Cool Border/InfoPanel/planinf"
@onready var yearinf: Label = $"Cool Border/InfoPanel/year"
@onready var solidinf: Label = $"Cool Border/InfoPanel/solidinf"
@onready var poplab: Label = $WorldPanel/PopulationPanel/poplab
@onready var reslab: Label = $"WorldPanel/Research Panel/reslab"
@onready var warint: Label = $"WorldPanel/War Panel/warint"
@onready var SOULint: Label = $WorldPanel/DivinityPanel/SOULint
@onready var purificationbar: ProgressBar = $Bars/purificationbar
@onready var popgrowthbar: ProgressBar = $Bars/popgrowthbar
@onready var researchgrowth: ProgressBar = $Bars/researchgrowth
@onready var wardrive: ProgressBar = $Bars/wardrive
@onready var timer: Timer = $Timer
@onready var beepanel: Panel = $beepanel
var loaded_data : Dictionary = {}
var pops: int = 10
var popgrowth = pops * .1
var drivegrowth: float = 0
var drive = 0
var reap = 0
var research = 1
var respon: float = 0
var tech = 0
var purecycle = 1
var WLcurrency = 0
var soulq = 1
var WILL = 0
var solid = 0
var prestige = 0
var popspeed = 10
var popmax: = 100
var researchmax = 50
var maxwar = 1000
var time: int = 0
var maxpurif = 100
var timerinterval = .5
var wardrive_value := 0
var researchgrowth_value := 0
var purificationbar_value := 0
var popgrowthbar_value := 0
func apply_loaded_data():
	pops = contents_to_save["pops"]
	drive = contents_to_save["drive"]
	reap = contents_to_save["reap"]
	respon = contents_to_save["respon"]
	time = contents_to_save["time"]
	soulq = contents_to_save["soulq"]
	solid = contents_to_save["solid"]
	WILL = contents_to_save["WILL"]
	prestige = contents_to_save["prestige"]
	research = contents_to_save["research"]
	wardrive_value = contents_to_save["wardrive_value"]
	purificationbar_value = contents_to_save["purificationbar_value"]
	popgrowthbar_value = contents_to_save["popgrowthbar_value"]
	researchgrowth_value = contents_to_save["researchgrowth_value"]
func loadbars():
	if loaded_data.has("wardrive_value"):
		wardrive.value = loaded_data["wardrive_value"]
	if loaded_data.has("researchgrowth_value"):
		researchgrowth.value = loaded_data["researchgrowth_value"]
	if loaded_data.has("purificationbar_value"):
		purificationbar.value = loaded_data["purificationbar_value"]
	if loaded_data.has("popgrowthbar_value"):
		popgrowthbar.value = loaded_data["popgrowthbar_value"]
func varupdatetext():
	popinf.text = str(pops)
	poplab.text = str(pops)
	warinf.text = str(drive)
	warint.text = str(drive)
	purinf.text = str(reap)
	reslab.text = str(respon)
	yearinf.text = str(time)
	SOULint.text = str(soulq)
	soulinf.text = str(soulq)
	solidinf.text = str(solid)
	wilinf.text = str(WILL)
	planinf.text = str(prestige)
	resinf.text = str(research)
	wardrive.value = wardrive_value
	popgrowthbar.value = popgrowthbar_value
	researchgrowth.value = researchgrowth_value
	purificationbar.value = purificationbar_value
func popgrowthtick():
	@warning_ignore("narrowing_conversion")
	popgrowthbar_value += popspeed
func _ready():
	load_game()
	apply_loaded_data()
	loadbars()
	varupdatetext()
	timer.wait_time = timerinterval
	timer.one_shot = false
	timer.timeout.connect(tickfinish)
	timer.start()
func tickfinish():
	time = time + 1
	popgrowthbar_value = popgrowthbar_value + popspeed
	tickyear()

func tickyear():
	print("year tick")
	addpops()
	accumulaterp()
	wardriveacum()
	purificationcycle()
	varupdatetext()

func addpops():
	if popgrowthbar.value == popmax:
		@warning_ignore("narrowing_conversion")
		pops = pops + popgrowth
		popmax = popmax + 10
		popgrowthbar_value = 0
		popgrowthbar.max_value = popmax
		print("popgrowth")
	else:
		pass

func accumulaterp():
	@warning_ignore("narrowing_conversion")
	researchgrowth_value = researchgrowth_value + respon
	researchgrowth.max_value = researchmax
	respon = pops * 0.05 + drive
	if researchgrowth_value == researchmax:
		researchgrowth_value = 0
		researchmax *= 2
		research += 1
	else:
		pass

func wardriveacum():
	@warning_ignore("narrowing_conversion")
	wardrive_value = wardrive_value + drivegrowth 
	wardrive.max_value = maxwar
	drivegrowth = pops * 0.01 + tech - drive
	if wardrive.value == maxwar:
		drive += 1
		wardrive_value = 0
	else:
		pass

func purificationcycle():
	purificationbar_value += purecycle
	purificationbar.max_value = maxpurif
	reap = pops * .1 * soulq
	if purificationbar.value == purificationbar.max_value:
		pops -= reap
		WILL += reap
		purificationbar_value = 0
	else:
		pass

func _on_1xspeed_pressed() -> void:
	timerinterval = .5
	_ready()
func _on_2xspeed_pressed() -> void:
	timerinterval = .25
	_ready()
func _on_4xspeed_pressed() -> void:
	timerinterval = .125
	_ready()
func _on_8xspeed_pressed() -> void:
	timerinterval = .0625
	_ready()

func _on_bee_pressed() -> void:
	var beetimer = 1.5
	beepanel.visible = not beepanel.visible
	timer.wait_time = beetimer
	timer.timeout.connect(beetext)

func beetext():
	beepanel.visible = not beepanel.visible

var save_path = "user://save_data.json"

func save_game(data: Dictionary) -> void:
	contents_to_save["purecycle"] = purecycle
	contents_to_save["maxpurif"] = maxpurif
	contents_to_save["reap"] = reap
	contents_to_save["purificationbar_value"] = purificationbar_value
	contents_to_save["popgrowth"] = popgrowth
	contents_to_save["popspeed"] = popspeed
	contents_to_save["popmax"] = popmax
	contents_to_save["popgrowthbar_value"] = popgrowthbar_value
	contents_to_save["researchmax"] = researchmax
	contents_to_save["respon"] = respon
	contents_to_save["researchgrowth_value"] = researchgrowth_value
	contents_to_save["drivegrowth"] = drivegrowth
	contents_to_save["maxwar"] = maxwar
	contents_to_save["pops"] = pops
	contents_to_save["drive"] = drive
	contents_to_save["WLcurrency"] = WLcurrency
	contents_to_save["research"] = research
	contents_to_save["WILL"] = WILL
	contents_to_save["soulq"] = soulq
	contents_to_save["prestige"] = prestige
	contents_to_save["time"] = time
	contents_to_save["solid"] = solid
	contents_to_save["wardrive_value"] = wardrive_value
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()
		print("💾 Game saved to", save_path)
	else:
		push_error("❌ Failed to save game")
	print(data)

var contents_to_save: Dictionary = {
	"purecycle": purecycle,
	"maxpurif": maxpurif,
	"reap": reap,
	"purificationbar_value": purificationbar_value,
	"popgrowth": popgrowth,
	"popspeed": popspeed,
	"popmax": popmax,
	"popgrowthbar_value": popgrowthbar_value,
	"researchmax": researchmax,
	"respon": respon,
	"researchgrowth_value": researchgrowth_value,
	"drivegrowth": drivegrowth,
	"maxwar": maxwar,
	"pops": pops,
	"drive": drive,
	"WLcurrency": WLcurrency,
	"research": research,
	"WILL": WILL,
	"soulq": soulq,
	"prestige": prestige,
	"time": time,
	"solid": solid,
	"wardrive_value": wardrive_value,
}

func load_game() -> Dictionary:
	if not FileAccess.file_exists(save_path):
		print("⚠️ No save file found")
		return {}
	var file = FileAccess.open(save_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var result = JSON.parse_string(content)
	if result is Dictionary:
		print("📂 Game loaded")
		loaded_data = result 
		print(result)
		for key in result.keys():
			contents_to_save[key] = result[key]
		return result
	else:
		push_error("❌ Failed to parse save file")
		return {}

func delete_save() -> void:
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)
		print("🗑️ Save deleted")

func _on_savebutton_pressed() -> void:
	save_game(contents_to_save)
	print("Saved!")
func _on_loadbutton_pressed() -> void:
	load_game()
	print("Loaded!")
func _on_deletebutton_pressed() -> void:
	delete_save()
	get_tree().quit()



func _on_settingsopen_pressed() -> void:
	pass # Replace with function body.
