
-- not a test, but a helper local function
local function is_truthy(condition)
  if condition then return true end
  return false
end

function test_true_is_truthy()
  assert_equal(__(true), is_truthy(true))
end

function test_false_is_not_truthy()
  assert_equal(__(false), is_truthy(false))
end

function test_nil_is_also_not_truthy()
  assert_equal(__(false), is_truthy(nil))
end

function test_everything_else_is_truthy()
  assert_equal(__(true), is_truthy(1))
  assert_equal(__(true), is_truthy(0))
  assert_equal(__(true), is_truthy({'tables'}))
  assert_equal(__(true), is_truthy({}))
  assert_equal(__(true), is_truthy("Strings"))
  assert_equal(__(true), is_truthy(""))
  assert_equal(__(true), is_truthy(function() return 'functions too' end))
end

-- Bonus note:
-- Is it better to use
--    if obj == nil then
-- or
--    if obj then
-- Why?

