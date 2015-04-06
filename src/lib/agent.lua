local ansicolors = require 'lib.ansicolors'

local function cwrite(str)
  io.write(ansicolors(str))
end

local function cprint(...)
  local args = {...}
  local buffer = {}
  for _,arg in ipairs(args) do table.insert(buffer, arg) end
  print(ansicolors(table.concat(buffer, '\t')))
end

local function merge_tables(destination, source)
  for k,v in pairs(source) do
    destination[k] = destination[k] == nil and v or destination[k] -- don't merge false, only nil
  end
  return destination
end

local function smart_quote(str)
  if type(str) ~= 'string' then return tostring(str) end
  local has_double, has_single = str:match('"'), str:match("'")

  if     has_double and has_single then
    return "[[" .. str .. "]]"
  elseif has_double and not has_single then
    return "'" .. str .. "'"
  end

  return '"' .. str .. '"'
end

local words_to_remove_from_traceback = { 'agent.lua', '[C]:', 'missions.lua' }

local function line_should_be_kept_in_traceback(line)
  for _,word in ipairs(words_to_remove_from_traceback) do
    if line:find(word, 1, true) then return false end
  end
  return true
end

local function clean_traceback()
  local str = debug.traceback()
  local buffer = {}
  for line in str:gmatch("[^\r\n]+") do
    if line == "stack traceback:" then
      table.insert(buffer, "The error happened here:")
    elseif line_should_be_kept_in_traceback(line) then
      table.insert(buffer, line)
    end
  end
  return table.concat(buffer, '\n')
end

local prefix = 'Assertion failed: Expected'

local function raise_assert_error(msg)
  error({ agent, msg, clean_traceback() })
end

local function invoke_callback(callback, ...)
  if type(callback)=='function' then callback(...) end
end

local mission_environment = {
  assert_true = function(condition, msg)
    if not condition then
      raise_assert_error( msg or ("%s %s to be true"):format(prefix, smart_quote(condition)) )
    end
  end,
  assert_not = function(condition, msg)
    if condition then
      raise_assert_error( msg or ("%s %s to be false"):format(prefix, smart_quote(condition)) )
    end
  end,
  assert_equal = function(a, b, msg)
    if not (a == b) then
      raise_assert_error( msg or ("%s %s to be equal to %s"):format(prefix, smart_quote(a), smart_quote(b)) )
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
  }),
  _LULZ = _G
}
setmetatable(mission_environment, { __index = _G })

local function run_test(test, options)
  local status, message = pcall(test.f)
  if status then
    test.status = "pass"
    invoke_callback(options.test_passed, test)
  elseif type(message) == "table" and message[1] == agent then
    test.status = "fail"
    test.message = message[2]
    test.trace = message[3]
    invoke_callback(options.test_failed, test)
  else
    test.status = "error"
    test.message = message
    test.trace = clean_traceback()
    invoke_callback(options.test_error, test)
  end
end

local function add_test_to_mission(mission, name, f)
  if type(f) == 'function' then
    table.insert(mission, {name = name, f = f})
  else
    rawset(mission, name, f)
  end
end

local function load_mission(mission, options)
  setmetatable(mission, {__index = mission_environment, __newindex = add_test_to_mission})

  local f, message

  if setfenv then
    f, message = loadfile(mission.path, 'bt')
  else
    f, message = loadfile(mission.path, 'bt', mission)
  end

  if not f then
    mission.status = 'file error'
    mission.message = message
    invoke_callback(options.file_error, mission)
    return mission
  end

  if setfenv then setfenv(f, mission) end

  local succeed, message = pcall(f)
  if not succeed then
    mission.status = 'syntax error'
    mission.message = message
    invoke_callback(options.syntax_error, mission)
    return mission
  end

  mission.status = 'loaded'
  return mission
end

local function run_mission(mission, options)
  if mission.status == "loaded" then
    mission.status = "complete"
    for _,test in ipairs(mission) do
      run_test(test, options)
      if test.status ~= 'pass' then
        mission.status = "incomplete"
        if options.stop_on_first_error then return end
      end
    end
  end
end

local function pad(str, len, filler)
  return str .. string.rep(filler, len - #str)
end

local function bracket(str)
  return "%{bright white}[%{reset}" .. str .. "%{bright white}]"
end

local function nice_status(status)
  if status == 'complete' then return bracket("%{green}Complete") end
  if status == 'incomplete' then return bracket("%{yellow}Incomplete") end
  if status == 'fail' or status:find('error') then return bracket("%{red}"..status) end
end

local function print_test(test)
  if test.status and test.status ~= 'pass' then
    cprint('%{blue}' .. test.name .. ': ' .. nice_status(test.status))
    cprint(test.message)
    cprint(test.trace)
  end
end

local function print_mission(mission)
  cprint(pad(mission.name, 50, '.') .. nice_status(mission.status))
  if mission.status == 'incomplete' then
    for _,test in ipairs(mission) do
      print_test(test)
    end
  elseif mission.status == 'file error' or mission.status == 'syntax error' then
    cprint(mission.message)
  end
end

function all_missions_complete(missions)
  for _,mission in ipairs(missions) do
    if mission.status ~= 'complete' then return false end
  end
  return true
end

local default_options = {
  test_passed  = function(test) cwrite("%{green}.") end,
  test_failed  = function(test) cwrite("%{red}F") end,
  test_error   = function(test) cwrite("%{red}E") end,
  file_error   = function(mission) cwrite("%{red}?") end,
  syntax_error = function(mission) cwrite("%{red}!") end,
  stop_on_first_error = true
}

-- Public interface

local agent = {}

function agent.run_missions(mission_specs, options)
  local result = {}
  local missions = merge_tables({}, mission_specs) -- makes a copy of mission_specs
  options = merge_tables(options or {}, default_options) -- merge_tables default values for options
  for _,mission in ipairs(missions) do
    load_mission(mission, options)
    run_mission(mission, options)
    table.insert(result, mission)
    if options.stop_on_first_error and mission.status ~= 'complete' then return result end
  end
  return result
end

function agent.print_missions(missions)
  cprint('\n\n%{bright magenta}***%{cyan} Mission status %{magenta}***%{reset}\n')
  for _, mission in ipairs(missions) do
    print_mission(mission)
  end
  if all_missions_complete(missions) then
    cprint("\n\n%{bright yellow}Congratulations! You have finished all the missions!\n")
  end
end

return agent


