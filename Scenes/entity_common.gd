extends RefCounted
class_name EntityCommon
# Common script for entities

##### SIGNALS #####
# Node signals

##### ENUMS #####
enum stances {HIGH, MIDDLE, LOW}

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
# high -> low
# low -> middle
# middle -> high
static func defending_stance_multiplier(user_stance : EntityCommon.stances, defending_stance: EntityCommon.stances) -> int:
	match user_stance:
		EntityCommon.stances.HIGH:
			match defending_stance:
				EntityCommon.stances.HIGH:
					return 0
				EntityCommon.stances.MIDDLE:
					return 2
				EntityCommon.stances.LOW:
					return 1
		EntityCommon.stances.MIDDLE:
			match defending_stance:
				EntityCommon.stances.HIGH:
					return 1
				EntityCommon.stances.MIDDLE:
					return 0
				EntityCommon.stances.LOW:
					return 2
		EntityCommon.stances.LOW:
			match defending_stance:
				EntityCommon.stances.HIGH:
					return 2
				EntityCommon.stances.MIDDLE:
					return 1
				EntityCommon.stances.LOW:
					return 0
	return 1 # default case, should not happen 

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received

