function test_local_function_inside_another_function()
  local function foo()
    return 'foo'
  end
  assert_equal(__('foo'), foo())
end

function test_local_function_with_parameters()
  local function sum(x,y)
    return x + y
  end
  assert_equal(__(10), sum(6,4))
end

function test_assign_function_to_variable()
  local function sum(x,y)
    return x + y
  end
  local f = sum
  assert_equal(__(10), f(3,7))
end

function test_assign_anonymous_function_to_variable()
  -- this is actually equivalent to the previous two tests
  local f = function(x,y)
    return x + y
  end
  assert_equal(__(10), f(5,5))
end

function test_recursive_functions()
  local function recurse(x)
    if x <= 0 then return 0 end
    return x + recurse(x-1)
  end
  assert_equal(__(55), recurse(10))
end

function test_return_multiple_values()
  local function mangle(x,y,z)
    return x*2, y+1, z-1
  end

  local a,b,c = mangle(1,2,3)
  assert_equal(__(2), a)
  assert_equal(__(3), b)
  assert_equal(__(2), c)
end

function test_ignore_returned_values_on_assignments()
  local function stuff()
    return 1,2,3,4,5,6
  end
  local _,_,x = stuff()
  assert_equal(__(3), x)
end

function test_use_returned_values_on_functions()
  local function repeat_parameter(p)
    return p, p
  end
  local function sum(x,y)
    return x + y
  end
  assert_equal(__(10), sum(repeat_parameter(5)))
end

function test_ignore_returned_values_as_parameters()
  local function stuff(p)
    return 1,2,3,4,5,6
  end
  local function sum(x,y)
    return x + y
  end
  assert_equal(__(3), sum(stuff()))
end

function test_only_the_last_invoked_function_returns_all_values_the_rest_return_just_one()
  local function numbers()
    return 10, 9, 8
  end
  local function sum(a,b,c,d)
    return a + b + c + d
  end
  assert_equal(__(37), sum(numbers(), numbers()))
end

function test_functions_can_access_variables_on_their_defining_scope()
  -- This mix of a scope and a function inside it is called "a closure"
  local value = 10
  local function change()
    value = 20
  end
  change()
  assert_equal(__(20), value)
end

function test_variable_number_of_arguments_with_dot_dot_dot()
  local third = function(...)
    local _,_,x = ...
    return x
  end
  assert_equal(__('c'), third('a','b','c','d'))
end





