
function test_assert()
  -- begin skip
  assert_true(true)
  if false then
  -- end skip
  assert_true(false) -- this should be true. This is how you write comments in Lua
  -- begin skip
  end
  -- end skip
end

function test_assert_with_message()
  -- begin skip
  assert_true(true, 'This should be true')
  if false then
  -- end skip
  assert_true(false, 'This should be true')
  -- begin skip
  end
  -- end skip
end

function test_assert_expression()
  local expected_value = __(2)
  local actual_value = 1 + 1
  assert_true(expected_value == actual_value)
end

function test_assert_equals()
  local expected_value = __(2)
  local actual_value = 1 + 1
  assert_equal(expected_value, actual_value)
end

function test_assert_fill_in_values()
  assert_equal(1 + 1, __(2))
end

function test_assert_not()
  assert_not(__(false), 'This should be false')
end
