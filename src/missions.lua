local agent = require 'agent.agent'

local mission_names = {
  'asserts',
  'variables',
  'numbers',
  'strings',
  'patterns',
  'control',
  'truthiness',
  'functions',
  'errors',
  'load',
  'tables',
  'tables_and_functions',
  'meta',
  'indices'
}

local missions = {}

for _, name in ipairs(mission_names) do
  table.insert(missions, { name = name, path = name .. '.lua' })
end

local results = agent.run_missions(missions)
agent.print_missions(results)




