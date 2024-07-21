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
@export var BASE_HEALTH := 10
@export var STANCE := EntityCommon.stances.MIDDLE

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _current_health := BASE_HEALTH

#==== ONREADY ====
@onready var onready_paths := {
	"health_label": $"HealthLabel",
	"defending_animation": $"DefendingStanceAnimation"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.health_label.text = "%s" % BASE_HEALTH
	_play_stance_anim(STANCE)

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
func hurt(amount: int, stance : EntityCommon.stances) -> void:
	_current_health -= amount * EntityCommon.defending_stance_multiplier(STANCE,stance)
	onready_paths.health_label.text = "%d" % _current_health
	if _current_health <= 0 :
		queue_free()

##### PROTECTED METHODS #####
func _play_stance_anim(stance : EntityCommon.stances) -> void:
	match stance:
		EntityCommon.stances.HIGH:
			onready_paths.defending_animation.play("defending_high")
		EntityCommon.stances.MIDDLE:
			onready_paths.defending_animation.play("defending_middle")
		EntityCommon.stances.LOW:
			onready_paths.defending_animation.play("defending_low")

##### SIGNAL MANAGEMENT #####
