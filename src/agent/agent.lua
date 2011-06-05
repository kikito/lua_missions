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

local function invoke_callback(callback, ...)
  if type(callback)=='function' then callback(...) end
end

local mission_environment = {
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
setmetatable(mission_environment, { __index = _G })

local function run_test(test, callbacks)
  local status, message = pcall(test.f)
  if status then
    test.status = "pass"
    invoke_callback(callbacks.test_passed, test)
  elseif type(message) == "table" and message[1] == agent then
    test.status = "fail"
    test.message = message[2]
    test.trace = message[3]
    invoke_callback(callbacks.test_failed, test)
  else
    test.status = "error"
    test.message = message
    test.trace = stripped_traceback()
    invoke_callback(callbacks.test_error, test)
  end
end

local function add_test_to_mission(mission, name, f)
  table.insert(mission, {name = name, f = f})
end

local function load_mission(name, path, callbacks)
  local mission = {name = name, path = path}

  local f, message = loadfile(path)
  if not f then
    mission.status = 'file error'
    mission.message = message
    invoke_callback(callbacks.file_error, mission)
    return mission
  end

  setfenv(f, mission)
  setmetatable(mission, {__index = mission_environment, __newindex = add_test_to_mission})
  local succeed, message = pcall(f)
  if not succeed then
    rawset(mission, 'status', 'syntax error')
    rawset(mission, 'message', 'message')
    invoke_callback(callbacks.syntax_error, mission)
    return mission
  end

  rawset(mission, 'status', 'loaded')
  return mission
end

function agent.run_mission(name, path, callbacks)
  local mission = load_mission(name, path, callbacks)

  if mission.status == "loaded" then
    mission.status = "complete"
    for _,test in ipairs(mission) do
      run_test(test, callbacks)
      if test.status ~= 'pass' then mission.status = "incomplete" end
    end
  end

  return mission
end

function agent.print_mission(mission)
  print(mission.name, "\t\t", mission.status)
  if mission.status == 'incomplete' then
    for _,test in ipairs(mission) do
      if test.status ~= 'pass' then
        print(test.name, test.status)
        print(test.message)
        print(test.trace)
      end
    end
  elseif mission.status == 'file error' or mission.status == 'syntax error' then
    puts(mission.message)
  end
end

return agent


