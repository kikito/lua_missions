function test_assert()
  assert_true(false) -- this should be true. This is how you write comments in Lua
end

function test_assert_with_message()
  assert_true(false, 'This should be true')
end

function test_assert_expression()
  local expected_value = __
  local actual_value = 1 + 1
  assert_true(expected_value == actual_value)
end

function test_assert_equals()
  local expected_value = __
  local actual_value = 1 + 1
  assert_equal(expected_value, actual_value)
end

function test_assert_fill_in_values()
  assert_equal(1 + 1, __)
end

function test_assert_not()
  assert_not(__, 'This should be false')
end
