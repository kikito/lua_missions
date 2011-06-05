function test_variables_are_defined_locally_with_local()
  local x = 'a local value'
  assert_equal(__('a local value'), x)
end

function local_variables_are_not_available_in_other_tests()
  assert_equal(__(nil), x)
end

function test_variables_are_defined_globally_by_default()
  y = 'a global value'
  assert_equal(__('a global value'), y)
end

function test_global_variables_are_available_in_other_tests()
  assert_equal(__('a global value'), y)
end

-- conclussion: don't use global variables unless it's really necesary

function test_local_variables_inside_do_end_are_invisible_outside()
  do
    local foo = 'foo'
    assert_equal(__('foo'), foo)
  end
  assert_equal(__(nil), foo)
end

function test_multiple_assignment_with_commas()
  local a,b,c = 1,2,3
  assert_equal(__(2), b)
end

function test_switching_variables()
  local a,b = 1,2
  a,b = b,a
  assert_equal(__(1), b)
end
