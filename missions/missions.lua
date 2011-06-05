local agent = require 'agent.agent'

local folder_separator = package.config:sub(1,1)

local mission_names = {
  'asserts',
  'nil',
  'local_vs_global',
  'numbers',
  'strings',
  'functions',
  'tables'
}

local callbacks = {
  test_passed  = function(test) io.write(".") end,
  test_failed  = function(test) io.write("F") end,
  test_error   = function(test) io.write("E") end,
  file_error   = function(mission) io.write("?") end,
  syntax_error = function(mission) io.write("!") end
}

local missions = {}
local mission, mission_path, results

for _, mission_name in ipairs(mission_names) do
  mission_path = '.' .. folder_separator .. mission_name .. '.lua'
  mission = agent.run_mission(mission_name, mission_path, callbacks)
  table.insert(missions, mission)
end

print('\nMission status:')

for _, mission in ipairs(missions) do
  agent.print_mission(mission)
end


