extends Resource
class_name BaseBulletStrategy

###########################################
# Strategy Relevant Code:
# This is the base strategy that all other
# bullet strategies will inherit from.
###########################################

@export var upgrade_text : String = "Speed"
@export var flavor_text : String = "Something something upgrading"

# This is the function that we later call when firing our bullet.
# Since we pass in the instance of the bullet, we can do anything
# to it that we could any other kind of node, plus more.
# Some examples include:
# 1. Editing simple variables (ex. bullet.damage += 5)
# 2. Calling any functions defined in the node
# 3. Attaching components or changing properties of any attached component
func apply_upgrade(item : Node2D):
	# This does nothing by default
	pass
