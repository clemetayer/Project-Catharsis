extends Node3D
# Player's weapon

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant = 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _stance : PlayerCommon.stances

#==== ONREADY ====
@onready var onready_paths := {
	"animation_player": $"AnimationPlayer",
	"animation_tree": $"AnimationTree"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.animation_player.play("FastMode")

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
func change_stance(stance : PlayerCommon.stances) -> void:
	var state_machine : AnimationNodeStateMachinePlayback = onready_paths.animation_tree.get("parameters/playback")
	match stance:
		PlayerCommon.stances.FAST:
			state_machine.travel("FastMode")
		PlayerCommon.stances.DEFENSE:
			state_machine.travel("ShieldMode")
		PlayerCommon.stances.STRONG:
			state_machine.travel("StrongMode")

func attack(stance: PlayerCommon.stances) -> void:
	var state_machine : AnimationNodeStateMachinePlayback = onready_paths.animation_tree.get("parameters/playback")
	_stance = stance
	match stance:
		PlayerCommon.stances.FAST:
			state_machine.travel("AttackFast")
		PlayerCommon.stances.DEFENSE:
			state_machine.travel("ShieldBash")
		PlayerCommon.stances.STRONG:
			state_machine.travel("StrongAttack")

##### PROTECTED METHODS #####
func _get_stance_damage() -> int:
	match _stance:
		PlayerCommon.stances.FAST:
			return 5
		PlayerCommon.stances.DEFENSE:
			return 2
		PlayerCommon.stances.STRONG:
			return 10
	return 0 # should never go here

##### SIGNAL MANAGEMENT #####
func _on_hitboxes_body_entered(body):
	if body.is_in_group("ennemy") and body.has_method("hurt"):
		body.hurt(_get_stance_damage(), _stance)
