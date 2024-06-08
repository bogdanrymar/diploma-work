class_name ScriptExecutor

var _emulator: Emulator
var _editor: Editor

var _context: ScriptExecutionContext = null
var _interrupted = false


func _init(emulator: Emulator, editor: Editor):
	_emulator = emulator
	_editor = editor


func prepare_context():
	Log.log("Preparing execution context")
	_context = ScriptExecutionContext.new()

	# Put player into the appropriate adapter and put into context
	var player_adapter = PlayerAdapter.new(_get_player())
	_context.put_entity(Strings.PLAYERS, player_adapter)


func _get_player() -> Node2D:
	var level = _emulator.level
	if not level:
		Log.error("No level loaded into the emulator")
		return null

	var player = level.player
	if not player:
		Log.error("No player found on the level")
		return null

	return player


func run() -> bool:
	if not _context:
		Log.error("Context is not initialized")
		return false

	var script = _editor.get_parsed_script()
	if not script:
		Log.warn("Script has not passed validity checks, execution prevented")
		return false

	_interrupted = false
	# Temporarily pause any editor checks to improve performance
	_editor.should_run_checks = false

	Log.log("Asking editor to begin script execution")
	var execution_successful: bool = await script.execute(_context)

	_editor.should_run_checks = true
	# Execution was successful
	return execution_successful


func interrupt():
	if not _context:
		Log.error("Context is not initialized")
		return

	_context.reset()
	_interrupted = true
