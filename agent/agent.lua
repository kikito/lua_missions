local agent = {}


local function stripped_traceback()
  local str = debug.traceback()
  local buffer = {}
  for line in str:gmatch("[^\r\n]+") do
    if not line:find('agent.lua') and not line:find('[C]:', 1, true) then
      table.insert(buffer, line)
    end
  end
  return table.concat(buffer, '\n')
end

local function raise_assert_error(msg)
  error({ agent, 'Assertion failed: Expected ' .. msg, stripped_traceback() })
end

local context = setmetatable({}, { __index = _G })

function context.assert_true(condition)
  if not condition then
    raise_assert_error( ("'%s' to be true"):format(tostring(condition)) )
  end
end

function context.assert_equals(a,b)
  if not (a == b) then
    raise_assert_error( ("'%s' to be equal to '%s'"):format(tostring(a), tostring(b)) )
  end
end

function context.assert_error(f)
  if pcall(f) then
    raise_assert_error( "an error" )
  end
end

context.__ = setmetatable({}, { __tostring = function() return '<FILL IN VALUE>' end })

local function invoke_test(func)
  local status, info = pcall(func)
  if status then return "pass", nil end
  if type(info) == "table" and info[1] == agent then return "fail", info end
  return "error", { info, debug.traceback() }
end

local function add_test_to_mission(mission, name, f)
  table.insert(mission, {name = name, f = f})
end

function agent.load_mission(filename)
  local f, message = loadfile(filename)
  if not f then error({ message, debug.traceback() }) end
  local mission = setmetatable({}, {__index = context, __newindex = add_test_to_mission})
  setfenv(f, mission)
  local status, message = pcall(f)
  if not status then error({ message, debug.traceback() }) end
  return mission
end

function agent.run_mission(mission)
  local results = {}
  local test

  for i=1, #mission do
    test = mission[i]
    local result = { name = test.name }
    result.status, result.info = invoke_test(test.f)
    table.insert(results, result)
  end

  return results
end

function agent.print_results(results)
  for i=1, #results do
    result = results[i]
    print(result.name, result.status)
    if result.status == 'fail' then
      print(result.info[2])
      print(result.info[3])
    end
    if result.status == 'error' then
      print(result.info)
    end
  end
end

return agent


