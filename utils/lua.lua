
-- TODO: Either force ubuntu to use a newer version of lua or... https://github.com/stevedonovan/Penlight/blob/master/lua/pl/compat.lua
if not table.pack then
    function table.pack (...)
        return {n=select('#',...); ...}
    end
end

if not table.indexOf then
	function table.indexOf(haystack, needle)
		for index, value in ipairs(haystack) do
	        if value == needle then
	            return index
	        end
	    end

	    return nil
	end
end

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
	local file = io.open(fileName or "saveFile.txt", "w")
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

-- trim string
-- SOURCE: http://lua-users.org/wiki/StringTrim#trim6
function trim(s)
	return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
end

-- Base path name
-- SOURCE: https://github.com/Donearm/scripts/blob/master/lib/basename.lua
function basename(str)
	return string.gsub(str, "(.*/)(.*)", "%2")
end

-- Round to given decimal places
-- SOURCE: http://stackoverflow.com/a/16036841/1469823
function round(val, decimal)
    local exp = decimal and 10^decimal or 1
    return math.ceil(val * exp - 0.5) / exp
end

function roundi(val)
    return math.ceil(val - 0.4)
end

function execForOutput(command)
	return readAll(io.popen(command))
end

function readFile(file)
	return readAll(io.open(file, "r"))
end

function readAll(stream, dontClose)
	local output = stream:read("*all")
	
	if not dontClose then
		stream:close()
	end
	
	return output
end
