extends CharacterBody3D
# Basic ennemy script

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant = 10 # Optionnal comment

#---- EXPORTS -----
@export var BASE_HEALTH := 30

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _current_health := BASE_HEALTH

#==== ONREADY ====
@onready var onready_paths := {
	"health_label": $"HealthLabel"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.health_label.text = "%s" % BASE_HEALTH
	_current_health = BASE_HEALTH

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
func hurt(amount: int, _stance: PlayerCommon.stances) -> void:
	_current_health -= amount
	onready_paths.health_label.text = "%d" % _current_health
	if _current_health <= 0 :
		queue_free()
	
	

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received

