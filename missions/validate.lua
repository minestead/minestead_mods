
local function assign_validation_result(meta, result)
	meta:set_int("valid", 0)
	meta:set_string("validationresult", result.msg)
end

local function clear_validation_result(meta)
	meta:set_int("valid", 1)
	meta:set_string("validationresult", "")
end

missions.validate_mission = function(pos, player)
	local steps = missions.get_steps(pos)
	local meta = minetest.get_meta(pos)

	if not steps then
		return { success=false, failed=true, msg="No steps" }
	end

	for i,step in ipairs(steps) do

		local spec = missions.get_step_spec_by_type(step.type)

		if not spec then
			local result = {
				msg="Validation failed in step " .. i ..
					" on mission: " .. pos.x .. "/" .. pos.y .. "/" .. pos.z ..
					" the step has no spec (specification): " .. step.type,
				success=false,
				failed=true
			}

			assign_validation_result(meta, result)
			return result

		end

		if spec.validate then
			local result = spec.validate({
				pos=pos,
				step=step
			})

			if result and result.failed then
				local validation_result = {
					msg="Validation failed in step " .. i ..
						" on mission: " .. pos.x .. "/" .. pos.y .. "/" .. pos.z ..
						" with message: " .. result.msg,
					success=false,
					failed=true
				}

				assign_validation_result(meta, validation_result)

				return validation_result
			end
		end
	end

	clear_validation_result(meta)

	return { success=true }
end
