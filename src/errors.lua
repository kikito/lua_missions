function test_basic_error_and_pcall()
  local value = 1
  local function problematic_func()
    value = 2
    error('this is an error message')
    value = 3
  end
  local status, message = pcall(problematic_func)

  assert_equal(__(2), value)
  assert_equal(__(false), status)
  -- the message includes file info, so it'll vary depending on the platform
  assert_equal(__(message), message)
end

function test_pcall_returns_true_followed_by_return_values_when_no_errors_are_raised()
  local function noproblemo()
    return 'foo', 'bar'
  end
  local status, x, y = pcall(noproblemo)

  assert_equal(__(true), status)
  assert_equal(__('foo'), x)
  assert_equal(__('bar'), y)
end

function test_pcall_can_pass_parameters_to_invoked_function()
  local function sum(x,y)
    return x+y
  end
  local status, result = pcall(sum, 10, 20)

  assert_equal(__(true), status)
  assert_equal(__(30), result)
end

function test_pcall_works_ok_on_anonymous_functions()
  local status, message = pcall(function() error('hi!') end)
  assert_equal(__(false), status)
  assert_equal(__(message), message)
end

function test_pcall_works_ok_on_error_itself()
  local status, message = pcall(error, 'Hello')
  assert_equal(__(false), status)
  assert_equal(__(message), message)
end

function test_error_removes_file_info_if_second_param_is_0()
  local _, message = pcall(error, 'World', 0)
  assert_equal(__('World'), message)
end

function test_error_returning_non_strings_converts_to_string_but_supresses_file_info()
  local _, message = pcall(error, 404)
  assert_equal(__('404'), message)
  -- not only numbers and strings are possible. You can returns tables, functions, etc too.
end

function test_assert_is_defined_by_lua()
  local status, message = pcall(function() assert(false, "This is an error") end)
  assert_equal(__(false), status)
  assert_equal(__(message), message)
  -- exercise left out to the reader: figure out how assert might be implemented
end
