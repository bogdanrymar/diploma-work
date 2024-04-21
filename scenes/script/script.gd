class_name RoboScript

var notices: Array[Notice] = []
var _script_block: CodeBlock = null


func parse(text: String):
	var statements = RoboScriptParser.parse(text)
	notices = RoboScriptValidator.validate(statements)

	# No notices - proceed to grouping
	if notices.is_empty():
		_script_block = RoboScriptFolder.fold(statements)


func execute(context: ScriptExecutionContext) -> Notice:
	if not _script_block:
		Log.warn("Script has not passed validity checks, execution prevented")
		return null

	for statement in _script_block.children:
		if statement is FunctionCodeBlock:
			if statement.is_start():
				Log.info("Executing start function")

				var notice = await statement.execute(context)
				if notice:
					return notice

				Log.info("Execution finished")
				return null

	Log.info("Start function not found")
	return null