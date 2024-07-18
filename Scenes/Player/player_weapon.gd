extends Node
class_name PlayerWeapon
# Player's weapon

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant = 10 # Optionnal comment

#---- EXPORTS -----
@export var DAMAGE := {
	EntityCommon.stances.HIGH: 3,
	EntityCommon.stances.MIDDLE: 2,
	EntityCommon.stances.LOW: 1,
}

#---- STANDARD -----
#==== PUBLIC ====
var stance : = EntityCommon.stances.MIDDLE

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
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg ):
#     pass

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
func _on_body_entered(body):
	if body.is_in_group("ennemy") and body.has_method("hurt"):
		body.hurt(DAMAGE[stance], stance)
