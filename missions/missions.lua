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
  'tables',
  'tables_and_functions',
  'meta',
  'indices'
}

local missions = {}
local folder_separator = package.config:sub(1,1) -- / for *nix, \ for windows
local path

for _, name in ipairs(mission_names) do
  path = '.' .. folder_separator .. name .. '.lua'
  table.insert(missions, { name = name, path = path })
end

local results = agent.run_missions(missions)
agent.print_missions(results)




