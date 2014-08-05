-- Bind a method call it it's object so it can be used as a normal function with it's object always being passed
function bindFunc(func, ...)
	local bound_args = table.pack(...);
	return function(...)
		local args = table.pack(...);
		for i=1, args.n do
			table.insert(bound_args, args[i]);
		end
		return func(unpack(bound_args));
	end
end

-- This is a wrapper function which passes a boolean to it's first parameter, it then inverts the boolean for the next time it is called
-- If it is given a second parameter, this parameter is the starting boolean (default is false)
function toggleStateFunc(functionToToggle, state)
	local state = state or false
	return function()
		functionToToggle(state)
		state = not state
	end
end

-- Delay
function delayFunc(delayTime, func, ...)
	-- Store additional arguments
	local bound_args = table.pack(...);
	-- Create Timer
	delayTimer = timer({timeout = delayTime})
	delayTimer:connect_signal("timeout", function()
		-- Unpack arguments & call function with them
		func(unpack(bound_args))
		-- Stop the timer
		delayTimer:stop()
	end)
	-- Start Timer
	delayTimer:start()
end

-- If the condition is true, returns the tVal, else it returns the fVal
function ternary(condition, tVal, fVal)
  if condition then return tVal else return fVal end
end

-- If the condition is true, returns the value of calling tValFunc, else it returns the value of calling fValFunc
-- NOTE: Any additional arguments to this function are passed to the applicable function when it is called
-- TODO: Test
function ternaryLazy(condition, tValFunc, fValFunc, ...)
	if condition then return tValFunc(...) else return fValFunc(...) end
end

-- Saves the content to the specified file name OR a default name (Over-Writes existing files)
function saveFile(content, fileName)
	file = io.open(fileName or "saveFile.txt", "w")
	file:write(content)
	file:close()
end

-- Split String
function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end