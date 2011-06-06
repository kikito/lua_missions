
function test_getfenv_returns_a_function_env_and_that_is_a_table()
  local function f() end
  local env = getfenv(f)
  assert_equal(__, type(env))
end

function test_getfenv_with_no_params_returns_the_current_function_env()
  global_var = 10
  local env = getfenv()
  env['global_var'] = 20
  assert_equal(__, global_var)
end

function test_local_variables_dont_appear_in_environments()
  local var = 10
  local function f() end
  local env = getfenv(f)
  assert_equal(__, env.var)
  -- this is an implementation detail. In reality, local vars are registers, not "real" variables
end

function test_setfenv_allows_the_modification_of_a_table_env()
  local function f() return x end
  setfenv(f, { x = 10 })
  assert_equal(__, f())
end

function test_values_not_defined_on_its_env_are_not_available_to_a_function()
  local function f() return type(x) end
  setfenv(f, {x=10})

  local status, message = pcall(f)

  assert_equal(__, status)
  assert_equal(__, message) -- if you change the spacing on this file, this will change
end

function test_red_pill()
  -- solving the problem above
  local function f() return type(10) end
  local env = getfenv(f)
  local new_env = setmetatable({x=10}, {__index = env})
  setfenv(f, new_env)

  local status, result = pcall(f)

  assert_equal(__, status)
  assert_equal(__, result)

  -- knock, knock Neo.
  -- did you think assert_equal, assert_not, etc came built-in in lua?
  -- you have been inside an intermediate environment this whole time
  -- see the agent.lua file
end

function test_the_global_environment_is_usually_in_underscore_G()
  assert_equal(__, type(_G['string']))
  -- the default stuff, like table, string, type, etc is defined there
  -- as well as the reference to _G itself
end

function test_here_the_global_environment_is_also_available_through_underscore_LULZ()
  assert_equal(__, type(_LULZ['string']))
  -- see the agent.lua file for details
end
  -- And now you know the truth, Neo. Your journey has just begun.






