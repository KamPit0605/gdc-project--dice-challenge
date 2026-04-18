extends Control



@export var PlayButton: Button
@export var CreditsButton: Button
@export var QuitButton: Button
@export var game_scene = "res://Scenes/game_scene.tscn"
#var mainMenu_scene
#var ConnectButtons: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#TitleUI.visible = false
	#Menu.visible = false
	#get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func UiScoreResets():
	GlobalDiceScript.AcquiredDice = 0
	GlobalPlayerScript.PlayerLevel = 1
	GlobalPlayerScript.PlayerXP = 0
	GlobalPlayerScript.LevelUpXP = 0
	GlobalPlayerScript.LevelUpQuota = GlobalPlayerScript.LevelUp1stQuota
	GlobalPlayerScript.EnemyKills = 0
	GlobalPlayerScript.autoAttacking_indicator = false
	GlobalGameSystem.GameReset = 0
	GlobalGameSystem.GamePlaying = false
	









func _on_main_menu_select():
	GlobalDiceScript.AcquiredDice = 0

func _credits():
	pass
	




func _on_play_button_pressed():
	GlobalGameSystem._restart()
	UiScoreResets()
	get_tree().change_scene_to_packed(GlobalSceneStorage.game_scene)


func _on_credits_button_pressed():
	_credits()


func _on_quit_button_pressed():
	get_tree().quit()
