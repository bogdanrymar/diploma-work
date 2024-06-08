extends Control

@onready var window_title_bar = %WindowTitleBar

@onready var emulator_tab = %EmulatorTab
@onready var emulator = %Emulator

@onready var run_button = %RunButton
@onready var rerun_button = %RerunButton
@onready var stop_button = %StopButton

@onready var user_log_tab = %UserLogTab
@onready var user_log = %UserLogTab/UserLog
@onready var code_tab = %CodeTab
@onready var code_editor = %CodeTab/Editor
@onready var docs_tab = %DocsTab
@onready var docs_editor = %DocsTab/Editor

var _current_level_resource = null

@onready var _executor = ScriptExecutor.new(emulator, code_editor)


func _ready():
	emulator_tab.name = Strings.TAB_EMULATOR
	user_log_tab.name = Strings.TAB_LOG
	code_tab.name = Strings.TAB_EDITOR
	code_editor.placeholder_text = Strings.TAB_EDITOR_PLACEHOLDER
	docs_tab.name = Strings.TAB_DOCS

	docs_editor.text = Utils.read_text_file("res://values/samples/docs.txt")


func open_level(level_name: String, level_sample: String, level_resource: Resource):
	Log.info("Opening level")
	Log.info("  - level_name:    ", level_name)
	Log.info("  - level_resource:", level_resource)

	# Update window title
	window_title_bar.title = level_name
	# Add sample code to the editor
	code_editor.text = level_sample
	# Setup emulator
	_current_level_resource = level_resource
	_load_level_into_emulator()


func _load_level_into_emulator():
	if _current_level_resource:
		emulator.level = _current_level_resource.instantiate()


func _on_run_button_pressed():
	run_button.hide()
	rerun_button.show()
	stop_button.show()

	_load_level_into_emulator()

	# Prepare context for the script to run within
	_executor.prepare_context()
	# Await for executor to finish
	await _executor.run()

	_on_stop_button_pressed()


func _on_rerun_button_pressed():
	_on_run_button_pressed()


func _on_stop_button_pressed():
	_executor.interrupt()

	run_button.show()
	rerun_button.hide()
	stop_button.hide()
