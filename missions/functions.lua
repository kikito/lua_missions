function test_local_function_inside_another_function()
  local function foo()
    return 'foo'
  end
  assert_equal(__, foo())
end

function test_local_function_with_parameters()
  local function sum(x,y)
    return x + y
  end
  assert_equal(__, sum(6,4))
end

function test_assign_function_to_variable()
  local function sum(x,y)
    return x + y
  end
  local f = sum
  assert_equal(__, f(3,7))
end

function test_assign_anonymous_function_to_variable()
  -- this is actually equivalent to the previous two tests
  local f = function(x,y)
    return x + y
  end
  assert_equal(__, f(5,5))
end

function test_functions_that_do_not_return_anything_return_nil()
  local f = function() end
  assert_equal(__, f())
end

function test_recursive_functions()
  local function recurse(x)
    if x <= 0 then return 0 end
    return x + recurse(x-1)
  end
  assert_equal(__, recurse(10))
end

function test_return_multiple_values()
  local function mangle(x,y,z)
    return x*2, y+1, z-1
  end

  local a,b,c = mangle(1,2,3)
  assert_equal(__, a)
  assert_equal(__, b)
  assert_equal(__, c)
end

function test_ignore_returned_values_on_assignments()
  local function stuff()
    return 1,2,3,4,5,6
  end
  local _,_,x = stuff()
  assert_equal(__, x)
end

function test_use_returned_values_on_functions()
  local function repeat_parameter(p)
    return p, p
  end
  local function sum(x,y)
    return x + y
  end
  assert_equal(__, sum(repeat_parameter(5)))
end

function test_ignore_returned_values_as_parameters()
  local function stuff(p)
    return 1,2,3,4,5,6
  end
  local function sum(x,y)
    return x + y
  end
  assert_equal(__, sum(stuff()))
end

function test_only_the_last_invoked_function_returns_all_values_the_rest_return_just_one()
  local function numbers()
    return 10, 9, 8
  end
  local function sum(a,b,c,d)
    return a + b + c + d
  end
  assert_equal(__, sum(numbers(), numbers()))
end

function test_parameters_not_passed_are_nil()
  local function unused_param(p)
    assert_equal(__, p)
  end
  unused_param()
end

function test_make_use_of_nil_for_default_values()
  local function add(number, amount)
    amount = amount or 1 -- very common language idiom for default values
    return number + amount
  end
  assert_equal(__, add(10))
end

function test_functions_can_access_variables_on_their_defining_scope()
  -- This mix of a scope and a function inside it is called "a closure"
  local value = 10
  local function change()
    value = 20
  end
  change()
  assert_equal(__, value)
end

function test_parenthesis_are_not_needed_on_invocation_when_the_only_parameter_is_a_string()
  local function count_spaces(str)
    local count = 0
    str:gsub(" ", function() count = count + 1 end) -- notice the closure here!
    return count
  end
  assert_equal(__, count_spaces "This string has four spaces") -- no parenthesis!
end

function test_parenthesis_are_not_needed_on_invocation_when_the_only_parameter_is_a_table()
  local function count_zeroes(t)
    local count = 0
    for i=1, #t do
      count = count + (t[i] == 0 and 1 or 0)
    end
    return count
  end
  assert_equal(__, count_zeroes {1, 0, 2, 3, 0, 4, 5, 6, 0, 7})
end

function test_variable_number_of_arguments_with_dot_dot_dot()
  local third = function(...)
    local _,_,x = ...
    return x
  end
  assert_equal(__, third('a','b','c','d'))
end


