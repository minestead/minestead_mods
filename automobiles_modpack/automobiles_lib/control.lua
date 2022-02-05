--global constants

automobiles_lib.vector_up = vector.new(0, 1, 0)

function automobiles_lib.check_road_is_ok(obj, max_acc_factor)
	local pos_below = obj:get_pos()
	pos_below.y = pos_below.y - 0.1
	local node_below = minetest.get_node(pos_below).name
    --minetest.chat_send_all(node_below)
    local nodedef = minetest.registered_nodes[node_below]
    if nodedef.liquidtype == "none" then
        local slow_nodes = {
                            ['default:ice '] = 0.1,
                            ['default:cave_ice'] = 0.1,
                            ['default:dirt'] = 0.5,
                            ['default:dirt_with_coniferous_litter'] = 0.6,
                            ['default:dirt_with_dry_grass'] = 0.6,
                            ['default:dirt_with_grass'] = 0.5,
                            ['default:dirt_with_rainforest_litter'] = 0.7,
                            ['default:dirt_with_snow'] = 0.5,
                            ['default:dry_dirt'] = 0.8,
                            ['default:dry_dirt_with_dry_grass'] = 0.7,
                            ['default:gravel'] = 0.6,
                            ['default:sand'] = 0.5,
                            ['default:silver_sand'] = 0.5,
                            ['default:desert_sand'] = 0.5,
                            ['default:snowblock'] = 0.5,
                           }
        local acc = slow_nodes[node_below]
        if acc == nil then acc = max_acc_factor end
        return acc
    else
        return 0
    end
end

function automobiles_lib.control(self, dtime, hull_direction, longit_speed, longit_drag, later_drag, accel, max_acc_factor, max_speed, steering_limit, steering_speed)
    self._last_time_command = self._last_time_command + dtime
    if self._last_time_command > 1 then self._last_time_command = 1 end

	local player = minetest.get_player_by_name(self.driver_name)
    local retval_accel = accel;
    local stop = false
    
	-- player control
	if player then
		local ctrl = player:get_player_control()
		
        local acc = 0
        if self._energy > 0 then
            if longit_speed < roadster.max_speed and ctrl.up then
                --get acceleration factor
                acc = automobiles_lib.check_road_is_ok(self.object, max_acc_factor)
                --minetest.chat_send_all('engineacc: '.. engineacc)
                if acc > 1 and acc < max_acc_factor and longit_speed > 0 then
                    --improper road will reduce speed
                    acc = -1
                end
            end


            --reversing
	        if ctrl.sneak and longit_speed <= 1.0 and longit_speed > -1.0 then
                acc = -2
	        end
        end

        --break
        if ctrl.down then
            --[[if math.abs(longit_speed) > 0 then
                acc = -5 / (longit_speed / 2) -- lets set a brake efficience based on speed
            end]]--
        
            --total stop
            --wheel break
            if longit_speed > 0 then
                acc = -5
                if (longit_speed + acc) < 0 then
                    acc = longit_speed * -1
                end
            end
            if longit_speed < 0 then
                acc = 5
                if (longit_speed + acc) > 0 then
                    acc = longit_speed * -1
                end
            end
            if math.abs(longit_speed) < 0.2 then
                stop = true
            end
        end

        if acc then retval_accel=vector.add(accel,vector.multiply(hull_direction,acc)) end

		if ctrl.aux1 then
            --[[
            --sets the engine running - but sets a delay also, cause keypress
            if self._last_time_command > 0.3 then
                self._last_time_command = 0
			    if self._engine_running then
				    self._engine_running = false
			        -- sound and animation
                    if self.sound_handle then
                        minetest.sound_stop(self.sound_handle)
                        self.sound_handle = nil
                    end
			        --self.engine:set_animation_frame_speed(0)

			    elseif self._engine_running == false and self._energy > 0 then
				    self._engine_running = true
		            -- sound and animation
	                self.sound_handle = minetest.sound_play({name = "engine"},
			                {object = self.object, gain = 2.0, pitch = 1.0, max_hear_distance = 32, loop = true,})
                    --self.engine:set_animation_frame_speed(30)
			    end
            end]]--
		end

		-- steering
		if ctrl.right then
			self._steering_angle = math.max(self._steering_angle-steering_speed*dtime,-steering_limit)
		elseif ctrl.left then
			self._steering_angle = math.min(self._steering_angle+steering_speed*dtime,steering_limit)
        else
            --center steering
            if longit_speed > 0 then
                local factor = 1
                if self._steering_angle > 0 then factor = -1 end
                local correction = (steering_limit*(longit_speed/75)) * factor
                local before_correction = self._steering_angle
                self._steering_angle = self._steering_angle + correction
                if math.sign(before_correction) ~= math.sign(self._steering_angle) then self._steering_angle = 0 end
            end
		end

        local angle_factor = self._steering_angle / 60
        if angle_factor < 0 then angle_factor = angle_factor * -1 end
        local deacc_on_curve = longit_speed * angle_factor
        deacc_on_curve = deacc_on_curve * -1
        if deacc_on_curve then retval_accel=vector.add(retval_accel,vector.multiply(hull_direction,deacc_on_curve)) end
    
	end

    return retval_accel, stop
end


