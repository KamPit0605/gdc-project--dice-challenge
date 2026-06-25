extends Control

@export var Player = CharacterBody3D

@onready var GameTimer = $"../Globals/GameSystem/Timers/Game_Timer" #direct reference
#--TEXTS--
@onready var HealthUI = $HealthLevelXP/HealthUI
@onready var LevelUI = $HealthLevelXP/LevelUI
@onready var XPUI = $HealthLevelXP/XPUI

@onready var TotalXPUI = $XPCoinsKills/TotalXPUI
@onready var CoinsUI = 0
@onready var KillsUI = $XPCoinsKills/KillsUI/KillsTextUI

@onready var HurtIndicator = $HurtIndicator
@onready var HurtIndicatorTimer = $HurtIndicatorTimer

@onready var AttackDice = $DiceContainer/AttackDice
@onready var AttackDiceNum = $DiceContainer/AttackDice/ADNumber
@onready var DefenseDice = $DiceContainer/DefenseDice
@onready var DefenseDiceNum = $DiceContainer/DefenseDice/DNumber
@onready var HealthDice = $DiceContainer/HealthDice
@onready var HealthDiceNum = $DiceContainer/HealthDice/HNumber
@onready var AbilityDice = $DiceContainer2/AbilityDice
@onready var AbilityDiceName = $DiceContainer2/AbilityDice/AName
var AbilityNames: String = "Ability"



@onready var MatchingUI = $"DiceContainer/DefenseDice/Matching!"

@onready var CriticalRoleUI = $VBoxContainer/Criticals/CriticalRoleUI
@onready var CriticalFailureUI = $VBoxContainer/Criticals/CriticalFailureUI
@onready var CriticalTimer = $CriticalTimer
var CriticalBool: bool = false 
@onready var OvertimeUI = $VBoxContainer/Criticals/Overtime/OvertimeUI
var OverTimeUIDisplay: bool
@onready var _1MinuteUI = $"VBoxContainer/Criticals/Time Alert/1MinuteUI"
var _1MinuteUIDisplay:bool = false

@onready var autoAttackUI = $AutoAttackIndicator/AutoAttack

@onready var TimerUI = $VBoxContainer/TimerUI
@onready var OverTimerUI = $VBoxContainer/OverTimerUI
@export var timeInSeconds: int #game timer set HERE
var timeDefault: int = 300
@export var overTimeInSeconds: int = 0
var TimerBool: bool
var OverTimerBool: bool
#--AUDIO--
@onready var AudioStreaming = $Audio/AudioStreamPlayer
@onready var AudioStreaming2 = $Audio/AudioStreamPlayer2D
@onready var AudioStreaming3 = $Audio/AudioStreamPlayer2D2

#GlobalPlayerScript
#GlobalDiceScript
#GlobalGameSystem

# Called when the node enters the scene tree for the first time.
func _ready():
	timeInSeconds = timeDefault
	AttackDice.visible = false
	DefenseDice.visible = false
	HealthDice.visible = false
	AbilityDice.visible = false
	if !GlobalGameSystem.GamePlaying:
		TimerUI.visible = false
		OverTimerUI.visible = false
	TimerBool = true
	MatchingUI.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GlobalGameSystem.GamePlaying == true:
		#--LowerUI--
		HealthUI.text = str(Player.HEALTH) + " / " + str(Player.MaxHealth) 
		LevelUI.text = str(GlobalPlayerScript.PlayerLevel)
	
		var LevelUpXPString = "%.0f" % GlobalPlayerScript.LevelUpXP
		var PlayerXPString = "%.0f" % GlobalPlayerScript.PlayerXP
		XPUI.text = str(LevelUpXPString) + " / " + str(GlobalPlayerScript.LevelUpQuota)
	
		#--TopRightUI--
		TotalXPUI.text = str(PlayerXPString)
		KillsUI.text = str(GlobalPlayerScript.EnemyKills)
	
	#--Dices--
	AttackDiceNum.text = str(GlobalDiceScript.AttackDNum)
	DefenseDiceNum.text = str(GlobalDiceScript.DefenseDNum)
	HealthDiceNum.text = str(GlobalDiceScript.HealthDNum)
	AbilityDiceName.text = AbilityNames
	
	if ((GlobalDiceScript.AcquiredDice >= 4) && (GlobalDiceScript.AttackDNum == GlobalDiceScript.DefenseDNum && GlobalDiceScript.DefenseDNum == GlobalDiceScript.HealthDNum)):
		if GlobalDiceScript.RollDice == false:
			MatchingUI.visible = true
		else:
			MatchingUI.visible = false
	
	#timeInSeconds = 5
	
	RollingAudio()
	#RolledAudio()
	
	#--Functions--
	_takingDamage()
	_showThoseDice()
	_abiltyDieNames()
	CriticalDisplay()
	OvertimeDisplay()
	_1MinuteDisplay()
	_timerSetup()
	_timeToOvertime()
	autoAttacking()
	#pass

func _takingDamage():
	
	if GlobalPlayerScript.DamageTaken == true:
		HurtIndicator.visible = true
		HurtIndicatorTimer.start(0.5)
		GlobalPlayerScript.DamageTaken = false
	

func _on_hurt_indicator_timer_timeout():
	HurtIndicator.visible = false
	



func _showThoseDice():
	if GlobalPlayerScript.PlayerLevel >= 1:
		if GlobalGameSystem.GamePlaying == true:
			AttackDice.visible = true
	if GlobalPlayerScript.PlayerLevel >= 5:
		AbilityDice.visible = true
	if GlobalPlayerScript.PlayerLevel >= 6:
		DefenseDice.visible = true
	if GlobalPlayerScript.PlayerLevel >= 8:
		HealthDice.visible = true
		
func _abiltyDieNames():
	if GlobalDiceScript.AcquiredDice >= 2:
		if GlobalDiceScript.AbilityDRole == 1:
			AbilityNames = "speed"
		elif GlobalDiceScript.AbilityDRole == 2:
			AbilityNames="shield"
		elif GlobalDiceScript.AbilityDRole == 3:
			AbilityNames="health"
		elif GlobalDiceScript.AbilityDRole == 4:
			AbilityNames="atk cldwn"
		elif GlobalDiceScript.AbilityDRole >= 5:
			AbilityNames="crit hit"

func CriticalDisplay():
	if ((GlobalDiceScript.RollDice == false) && (CriticalBool == false) && (GlobalDiceScript.AcquiredDice >= 4)):
		if ((GlobalDiceScript.AttackDNum == 6) && (GlobalDiceScript.DefenseDNum == 6) && (GlobalDiceScript.HealthDNum == 6)):
			CriticalRoleUI.visible = true
			CriticalTimer.start(2.0)
			GlobalUi.CriticalRoleRate = 1
			AudioPlaying("res://Audio/SFX/SPLTN/GachiStateChange2.wav")
			CriticalBool = true
		elif ((GlobalDiceScript.AttackDNum == 1) && (GlobalDiceScript.DefenseDNum == 1) && (GlobalDiceScript.HealthDNum == 1)):
			CriticalFailureUI.visible = true
			CriticalTimer.start(2.0)
			GlobalUi.CriticalRoleRate = 2
			AudioPlaying("res://Audio/SFX/SPLTN/GachiStateBack.wav")
			CriticalBool = true
func OvertimeDisplay():
	if ((GlobalGameSystem.OVERTIME || OverTimerBool)&&(OverTimeUIDisplay == false)):
		OvertimeUI.visible = true
		OverTimeUIDisplay = true
		CriticalTimer.start(2.0)
		AudioPlaying("res://Audio/SFX/G&W SHUTTR/00018 - .wav")
func _1MinuteDisplay():
	if (((timeInSeconds >= 58) && (timeInSeconds <= 59))&&(_1MinuteUIDisplay == false)):
		_1MinuteUI.visible = true
		_1MinuteUIDisplay = true
		CriticalTimer.start(2.0)
		AudioPlaying("res://Audio/SFX/G&W SHUTTR/00020 - .wav")

func _on_critical_timer_timeout():
	CriticalRoleUI.visible = false
	CriticalFailureUI.visible = false
	OvertimeUI.visible = false
	_1MinuteUI.visible = false
	if GlobalDiceScript.RollDice == true:
		CriticalBool = false
		GlobalUi.CriticalRoleRate = 0

func _timerSetup():
	if GlobalGameSystem.GameStart:
		TimerUI.visible = true
		GameTimer.start()
		AudioPlaying("res://Audio/SFX/WWE/WWE Royal Rumble Buzzer (2003 - Present)_1.mp3")

func _timeToOvertime():
	if timeInSeconds <= -1:
		TimerUI.visible = false
		OverTimerUI.visible = true
		OverTimerBool = true
		TimerBool = false
		timeInSeconds = 0
		GlobalGameSystem.OVERTIME = true

func _on_game_timer_timeout():
	var m = int(timeInSeconds/60.0)
	var s = timeInSeconds - m * 60
	if TimerBool == true:
		timeInSeconds -= 1
		TimerUI.text = '%01d:%02d' % [m,s]
	if OverTimerBool == true:
		timeInSeconds += 1
		OverTimerUI.text = "+"+'%01d:%02d' % [m,s]

func autoAttacking():
	if GlobalPlayerScript.autoAttacking_indicator == true:
		autoAttackUI.visible = true
	else:
		autoAttackUI.visible = false

func GameReset():
	if GlobalGameSystem.GameReset:
		timeInSeconds = timeDefault

func AudioPlaying(SFX):
	AudioStreaming.stream = load(SFX)
	AudioStreaming.play()
func _AudioPlaying2(SFX):
	AudioStreaming2.stream = load(SFX)
	AudioStreaming2.play()
func _AudioPlaying3(SFX):
	AudioStreaming3.stream = load(SFX)
	AudioStreaming3.play()

func RollingAudio():
	if (GlobalDiceScript.RollingSFX == true) && (GlobalGameSystem.GamePlaying == true):
		_AudioPlaying2("res://Audio/SFX/MBYB/ 0094 - Sound Effects - 4 Game Fun Pack Monopoly Boggle _1.mp3")
		if (GlobalDiceScript.AcquiredDice >= 2):
			_AudioPlaying3("res://Audio/SFX/SPLTN/Roulette01eq.wav")
func RolledAudio():
	#if (GlobalDiceScript.RolledSFX == true) && (GlobalGameSystem.GamePlaying == true):
	_AudioPlaying2("res://Audio/SFX/MK/SE_RC_ITEM_DECIDE.wav")
	if (GlobalDiceScript.AcquiredDice >= 2):
		_AudioPlaying3("res://Audio/SFX/SPLTN/Plz_GearDetail_AddSlot.wav")



func _on_dice_system_dice_rolled():
	if (GlobalDiceScript.RolledSFX) && (GlobalGameSystem.GamePlaying):
		RolledAudio()
