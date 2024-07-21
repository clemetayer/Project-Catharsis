extends AnimationPlayer
# player's weapon animation

##### SIGNALS #####
# Node signals

##### ENUMS #####

##### VARIABLES #####
#---- CONSTANTS -----
# const constant = 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
# onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
func play_stance_idle(stance : EntityCommon.stances) -> void:
	match stance:
		EntityCommon.stances.HIGH:
			play("idle_high")
		EntityCommon.stances.MIDDLE:
			play("idle_middle")
		EntityCommon.stances.LOW:
			play("idle_low")

func play_stance_attack(stance : EntityCommon.stances) -> void:
	match stance:
		EntityCommon.stances.HIGH:
			play("attack_high")
		EntityCommon.stances.MIDDLE:
			play("attack_middle")
		EntityCommon.stances.LOW:
			play("attack_low")

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received

