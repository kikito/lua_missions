local agent = require 'lib.agent'

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
  'indices',
  'exercise',
  'weak_tables'
}

local missions = {}

for _, name in ipairs(mission_names) do
  table.insert(missions, { name = name, path = name .. '.lua' })
end

-- begin skip
local results = agent.run_missions(missions, {stop_on_first_error = false})
if false then
-- end skip
local results = agent.run_missions(missions)
-- begin skip
end
-- end skip
agent.print_missions(results)




