function test_brackets_convert_dot_dot_dot_to_table()
  local third = function(...)
    local args = {...}
    return args[3]
  end
  assert_equal(__('c'), third('a','b','c','d'))
end

function test_unpack_for_converting_a_table_into_params()
  local params = {1,2,3}
  local sum = function(a,b,c)
    return a+b+c
  end
  assert_equal(__(6), sum(unpack(params)))
end

function test_functions_can_be_inserted_into_tables_and_invoked()
  local foo = function() return "foo" end
  local t = {}
  t[1] = foo
  assert_equal(__('foo'), t[1]())
end

function test_function_variables_can_be_used_as_literal_table_elements()
  local foo = function() return "foo" end
  local t = { foo }
  assert_equal(__('foo'), t[1]())
end

function test_anonymous_functions_can_be_used_as_literal_table_elements()
  local t = { function() return "foo" end }
  assert_equal(__('foo'), t[1]())
end

function test_functions_can_be_inserted_into_tables_with_strings_and_invoked()
  local bar = function() return "bar" end
  local t = {}
  t.bar = bar
  assert_equal(__('bar'), t.bar())
end

function test_function_variables_can_be_used_as_literal_table_elements_when_using_strings_as_keys()
  local bar = function() return "bar" end
  local t = { bar = bar }
  assert_equal(__('bar'), t.bar())
end

function test_anonymous_functions_can_be_used_as_literal_table_elements_when_using_strings_as_keys()
  local t = { bar = function() return "bar" end }
  assert_equal(__('bar'), t.bar())
end

function test_syntactic_sugar_for_declaring_functions_indexed_by_strings()
  -- declaring a function inside a table with a string is so common that Lua
  -- provides some syntactic sugar just for that:
  local t = {}
  function t.bar() return "bar" end
  assert_equal(__('bar'), t.bar())
end

function test_colon_syntactic_sugar_for_calling_functions_that_use_the_table_they_are_in_as_param()

  local t = { 1, 2, 3, 4, 5, 6 }
  function t.even(x)
    local result = {}
    for i=2, #x, 2 do
      table.insert(result, x[i])
    end
    return result
  end

  local result1 = t.even(t)
  local result2 = t:even() -- notice that we used a colon instead of a dot here

  -- these two assertions should expect the same result
  assert_equal(__('2, 4, 6'), table.concat(result1, ', '))
  assert_equal(__('2, 4, 6'), table.concat(result2, ', '))
end

function test_automatic_first_parameter_called_self_when_using_colon_in_declaration()
  local t = { 1, 2, 3, 4, 5, 6 }
  function t:even() -- notice the colon here
    local result = {}
    for i=2, #self, 2 do           -- notice the "self"
      table.insert(result, self[i])
    end
    return result
  end

  local result = t:even()
  assert_equal(__('2, 4, 6'), table.concat(result, ', '))
end
