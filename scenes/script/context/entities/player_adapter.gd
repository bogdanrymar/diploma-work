class_name PlayerAdapter
extends ContextEntity


func take_off(_ignored: String = "") -> bool:
	return await _entity.take_off()


func злетіти(_ignored: String = "") -> bool:
	return await take_off()


func land(_ignored: String = "") -> bool:
	return await _entity.land()


func сісти(_ignored: String = "") -> bool:
	return await land()


func up(s_steps: String = "1") -> bool:
	return await _move(s_steps, Vector2i.UP)


func вверх(s_steps: String = "1") -> bool:
	return await up(s_steps)


func down(s_steps: String = "1") -> bool:
	return await _move(s_steps, Vector2i.DOWN)


func вниз(s_steps: String = "1") -> bool:
	return await down(s_steps)


func left(s_steps: String = "1"):
	return await _move(s_steps, Vector2i.LEFT)


func вліво(s_steps: String = "1"):
	return await left(s_steps)


func right(s_steps: String = "1"):
	return await _move(s_steps, Vector2i.RIGHT)


func вправо(s_steps: String = "1"):
	return await right(s_steps)


func _move(s_steps: String, direction: Vector2i):
	if not _entity:
		Log.error("Dead player in the adapter")
		return

	# Parse steps argument
	var steps = Utils.string_to_int(s_steps, 0)
	# Calculate directed movement vector
	var steps_delta = direction * steps

	# Pass the vector to the entity
	return await _entity.move_by(steps_delta)
