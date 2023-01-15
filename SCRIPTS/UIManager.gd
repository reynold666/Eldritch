extends Control

onready var sanityBar = $SanityBar
onready var spiritualBar = $SpiritualBar
onready var teleportIconActive = $Teleport/Box
onready var teleportIconInactive = $Teleport/Reload
onready var speedIconActive = $Speed/Box
onready var speedIconInactive = $Speed/Reload
onready var phaseShiftIconActive = $PhaseShift/Box
onready var phaseShiftIconInactive = $PhaseShift/Reload
	
func set_sanity_relative(relativeSanity):
	sanityBar.value = relativeSanity

func set_spiritual_relative(relativeSanity):
	sanityBar.value = relativeSanity

func set_sanity_absolute(sanityValue, sanityMaximum, sanityMinimum = 0):
	set_sanity_relative(sanityValue-sanityMinimum/sanityMaximum-sanityMinimum)

func set_spiritual_absolute(spiritualValue, spiritualMaximum, spiritualMinimum = 0):
	set_spiritual_relative(spiritualValue-spiritualMinimum/spiritualMaximum-spiritualMinimum)

func set_speed_active(speedIsActive):
	speedIconActive.visible = speedIsActive
	speedIconInactive.visible = !speedIsActive
		
func set_phase_shift_active(phaseShiftIsActive):
	speedIconActive.visible = phaseShiftIsActive
	speedIconInactive.visible = !phaseShiftIsActive
	
func set_teleport_active(teleportIsActive):
	teleportIconActive.visible = teleportIsActive
	teleportIconInactive.visible = !teleportIsActive
