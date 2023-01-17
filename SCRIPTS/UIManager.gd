extends CanvasLayer

onready var belowSpiritColor = Color(0.3, 0.3, 0.5, 0.6)

onready var sanityBar = $SanityBar
onready var spiritualBar = $SpiritualBar
onready var teleportIconActive = $HBox/Teleport/Box
onready var teleportIconInactive = $HBox/Teleport/Reload
onready var speedIconActive = $HBox/Speed/Box
onready var speedIconInactive = $HBox/Speed/Reload
onready var phaseShiftIconActive = $HBox/PhaseShift/Box
onready var phaseShiftIconInactive = $HBox/PhaseShift/Reload
onready var spectralVisionIconActive = $HBox/SpectralVision/Box
onready var spectralVisionIconInactive = $HBox/SpectralVision/Reload

func set_sanity_relative(relativeSanity):
	sanityBar.value = relativeSanity

func set_spiritual_relative(relativeSpiritual):
	spiritualBar.value = relativeSpiritual

func set_sanity_absolute(sanityValue, sanityMaximum, sanityMinimum = 0):
	set_sanity_relative(sanityValue-sanityMinimum/sanityMaximum-sanityMinimum)

func set_spiritual_absolute(spiritualValue, spiritualMaximum, spiritualMinimum = 0):
	set_spiritual_relative(spiritualValue-spiritualMinimum/spiritualMaximum-spiritualMinimum)

func set_power_walk_active(speedIsActive):
	speedIconActive.visible = speedIsActive
	speedIconInactive.visible = !speedIsActive
		
func set_phase_shift_active(phaseShiftIsActive):
	phaseShiftIconActive.visible = phaseShiftIsActive
	phaseShiftIconInactive.visible = !phaseShiftIsActive
	
func set_teleport_active(teleportIsActive):
	teleportIconActive.visible = teleportIsActive
	teleportIconInactive.visible = !teleportIsActive
	
func set_spectral_vision_active(spectralVisionIsActive):
	spectralVisionIconActive.visible = spectralVisionIsActive
	spectralVisionIconInactive.visible = !spectralVisionIsActive
	
	
func set_power_walk_reload(relSpeedReload):
	speedIconInactive.value = relSpeedReload
		
func set_phase_shift_reload(relPhaseShiftReload):
	phaseShiftIconInactive.value = relPhaseShiftReload
	
func set_teleport_reload(relTeleportReload):
	teleportIconInactive.value = relTeleportReload
	
func set_spectral_vision_reload(relSpectralVisionReload):
	spectralVisionIconInactive.value = relSpectralVisionReload
	
func set_power_walk_spirit_tint(isAboveSpiritThreshold):
	if isAboveSpiritThreshold:
		speedIconActive.modulate = Color.white
	else:
		speedIconActive.modulate = belowSpiritColor
	
func set_phase_shift_spirit_tint(isAboveSpiritThreshold):
	if isAboveSpiritThreshold:
		phaseShiftIconActive.modulate = Color.white
	else:
		phaseShiftIconActive.modulate = belowSpiritColor
	
func set_teleport_spirit_tint(isAboveSpiritThreshold):
	if isAboveSpiritThreshold:
		teleportIconActive.modulate = Color.white
	else:
		teleportIconActive.modulate = belowSpiritColor
	
func set_spectral_vision_spirit_tint(isAboveSpiritThreshold):
	if isAboveSpiritThreshold:
		spectralVisionIconActive.modulate = Color.white
	else:
		spectralVisionIconActive.modulate = belowSpiritColor
