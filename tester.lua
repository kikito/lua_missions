local agent = require 'agent.agent'


local mission = agent.load_mission('./missions/asserts_mission.lua')

local results = agent.run_mission(mission)

agent.print_results(results)

