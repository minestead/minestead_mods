local highload_nodes = {}

local mesecon_queue_execute = mesecon.queue.execute

function mesecon.queue.execute(self, action)
  local t0 = minetest.get_us_time()
  mesecon_queue_execute(self, action)
  local t1 = minetest.get_us_time()
  local delta_t = t1 - t0

  local idx = minetest.pos_to_string(action.pos) .. " " .. action.func
  -- known nodes
--[[
  if idx == "(395,1,885)" or idx == "(378,18,884)" or idx == "(395,1,885)" or idx == "(392,-2,889)" or idx == "(396,8,882)" or idx == "(397,8,883)" or idx == "(391,-2,891)" then
    idx = 'hugeping'
  end
  if idx == "(-1156,39,1774)" or idx == "(-1165,45,1771)" or idx == "(-1158,34,1767)" or idx == "(-1162,34,1767)" or idx == "(-1163,38,1774)" or idx == "(-1161,33,1765)" or idx == "(-1163,38,1773)" or idx == "(-1162,34,1771)" or idx == "(-1158,34,1771)" or idx == "(-1166,36,1767)" or idx == "(-1167,40,1773)" or idx == "(-1167,40,1762)" then
    idx = 'casper'
  end
  if idx == "(-1484,9,1152)" or idx == "(-1485,9,1156)" then
    idx = 'pyramid_nightclub'
  end
  if idx == "(-1265,26,1194)" or idx == "(-1122,-3,1052)" then
    idx = 'irremann'
  end
  if idx == "(-429,11,599)" or idx == "(-2174,-3,490)" or idx == "(-429,11,600)" then
    idx = 'technix'
  end
]]--

  if highload_nodes[idx] == nil then
    highload_nodes[idx] = delta_t
  else
    highload_nodes[idx] = highload_nodes[idx] + delta_t
  end
end


vm_commit_time = {}

local mesecon_vm_commit = mesecon.vm_commit

function mesecon.vm_commit()
  local t0 = minetest.get_us_time()
  mesecon_vm_commit()
  local t1 = minetest.get_us_time()
  local delta_t = t1 - t0

  table.insert(vm_commit_time, delta_t)
end


function avg (tbl)
    local count = #tbl
    local result = 0
    for i, v in ipairs( tbl ) do
      result = result + v
    end
    return result / count
end

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end
    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end



local updatetimer = 0
minetest.register_globalstep(function(dtime)
  updatetimer = updatetimer + dtime
  if updatetimer > 10 then
    local total = 0
    for idx, node_time in pairs(highload_nodes) do
       total = total + node_time
    end
    local total_percentage = 0
    local limit = 10
    for key, value in spairs(highload_nodes, function(t,a,b) return t[b] < t[a] end) do
      local percentage = math.ceil(value/total*100)
      print(key .. " = " .. value .. " " .. percentage .. "%")
      total_percentage = total_percentage + percentage
      limit = limit - 1
      if limit == 0 then
        break
      end
    end
    print("Top 10 nodes take "..total_percentage.."%")
    print("AVG vm_commit time: "..avg(vm_commit_time))
    updatetimer = 0
  end
end)
