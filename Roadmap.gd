extends Node

# Roadmap! 

# Player
# - Vaulting (When you hit the corner of a wall you automatically climb to the top)
# - Top-collision avoidance (Four raycasts at left and right top of the player, if say the left side hits the roof but the right side doesn't, move the player to the right to avoid getting stuck on the corner)
# - A hit effect on the player when the player takes damage
# 	- And a minor knockback to the player

# Enemy
# - DarkBot isn't always facing the player.. Fix it
# - Give DarkBot the ability to jump if there is a wall between it and the player

# State Machine
# - Rework state to have an initialize method that is called from the state machine, this handles setup of the actor etc. instead of doing it every time we enter a state...
# - Add states as a child to the state superclass (to remove need to call state_machine.states.$ every time you want to change state)
