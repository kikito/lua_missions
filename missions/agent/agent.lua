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

local prefix = 'Assertion failed: Expected '

local function raise_assert_error(msg)
  error({ agent, msg, stripped_traceback() })
end

local test_environment = {
  assert_true = function(condition, msg)
    if not condition then
      raise_assert_error( msg or ("%s '%s' to be true"):format(prefix, tostring(condition)) )
    end
  end,
  assert_not = function(condition, msg)
    if condition then
      raise_assert_error( msg or ("%s '%s' to be false"):format(prefix, tostring(condition)) )
    end
  end,
  assert_equal = function(a, b, msg)
    if not (a == b) then
      raise_assert_error( msg or ("%s '%s' to be equal to '%s'"):format(prefix, tostring(a), tostring(b)) )
    end
  end,
  assert_error = function(f, msg)
    if type(f) ~= 'function' then raise_assert_error( "Function expected" ) end
    if pcall(f) then
      raise_assert_error( msg or prefix .. " an error" )
    end
  end,
  __ = setmetatable({}, {
    __add = function() return 0 end,
    __tostring = function() return '<FILL IN VALUE>' end,
    __call = function(_, ...) return ... end
  })
}
setmetatable(test_environment, { __index = _G })

local function invoke_test(func)
  local status, info = pcall(func)
  if status then return "pass", nil end
  if type(info) == "table" and info[1] == agent then return "fail", info end
  return "error", { info, debug.traceback() }
end

local function add_test_to_mission(mission, name, f)
  table.insert(mission, {name = name, f = f})
end

function agent.load_mission(name, path)
  local f, message = loadfile(path)
  if not f then error(message) end
  local mission = setmetatable({name = name}, {__index = test_environment, __newindex = add_test_to_mission})
  setfenv(f, mission)
  local status, message = pcall(f)
  if not status then error(message) end
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
      print(result.info[1], result.info[2])
    end
  end
end

return agent


