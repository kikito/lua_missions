function test_type_of_nil()
  assert_equal(type(nil), __('nil'))
end

function test_convert_nil_to_string()
  assert_equal(tostring(nil), __('nil'))
end

function test_default_values_of_variables()
  local foo
  assert_equal(foo, __(nil))
end

function test_operating_with_nil_throws_errors()
  assert_error(function()  -- note the anonymous function. This is needed for assert_error
    return 1 + __(nil)
  end)
end

-- Bonus note:
-- Is it better to use
--    if obj == nil then
-- or
--    if obj then
-- Why?

