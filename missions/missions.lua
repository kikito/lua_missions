local agent = require 'agent.agent'

local mission_names = {
  'asserts',
  'nil',
  'strings'
}

local missions = {}

local mission_name, mission
for i=1, #mission_names do
  mission_name = mission_names[i]
  mission = agent.load_mission(mission_name, './' .. mission_name .. '.lua')
  table.insert(missions, mission)
end

local results
for i=1, #missions do
  print('\n*** NEW MISSION: ' .. mission.name .. ' ***\n')
  results = agent.run_mission(missions[i])
  agent.print_results(results)
end


