jumpdrive.tubelib_compat = function(from, to)
	if not tubelib.jump then
		-- only works with the patched version
		return
	end
	tubelib.jump(from, to)
end
