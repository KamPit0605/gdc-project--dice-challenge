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

@onready var CriticalRoleUI = $VBoxContainer/Criticals/CriticalRoleUI
@onready var CriticalFailureUI = $VBoxContainer/Criticals/CriticalFailureUI
@onready var CriticalTimer = $CriticalTimer
var CriticalBool:bool 

@onready var TimerUI = $VBoxContainer/TimerUI
@onready var OverTimerUI = $VBoxContainer/OverTimerUI
@export var timeInSeconds: int = 300
#GlobalPlayerScript

# Called when the node enters the scene tree for the first time.
func _ready():
	AttackDice.visible = false
	DefenseDice.visible = false
	HealthDice.visible = false
	AbilityDice.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
	
	#--Functions--
	_takingDamage()
	_showThoseDice()
	_abiltyDieNames()
	CriticalDisplay()
	_timerSetup()
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
	if !GlobalDiceScript.RollDice:
		if ((GlobalDiceScript.AttackDNum == 6) && (GlobalDiceScript.DefenseDNum == 6) && (GlobalDiceScript.HealthDNum == 6)):
			CriticalRoleUI.visible = true
			CriticalTimer.start(2,0)
		elif ((GlobalDiceScript.AttackDNum == 1) && (GlobalDiceScript.DefenseDNum == 1) && (GlobalDiceScript.HealthDNum == 1)):
			CriticalFailureUI.visible = true
			CriticalTimer.start(2.0)

func _on_critical_timer_timeout():
	CriticalRoleUI.visible = false
	CriticalFailureUI.visible = false

func _timerSetup():
	if GlobalGameSystem.GameStart:
		TimerUI.visible = true
		GameTimer.start()


func _on_game_timer_timeout():
	timeInSeconds -= 1
	var m = int(timeInSeconds/60.0)
	var s = timeInSeconds - m * 60
	TimerUI.text = '%01d:%02d' % [m,s]
