

function test_double_quoted_strings_are_strings()
  local str = "Hello, World"
  assert_equal(__('string'), type(str))
end

function test_single_quoted_strings_are_also_strings()
  local str = 'Goodbye, World'
  assert_equal(__('string'), type(str))
end

function test_use_single_quotes_to_create_str_with_double_quotes()
  local str = 'He said, "Go Away."'
  assert_equal(__('He said, "Go Away."'), str)
end

function test_use_double_quotes_to_create_strings_with_single_quotes()
  local str = "Don't"
  assert_equal(__("Don't"), str)
end

function test_use_backslash_for_those_hard_cases()
  local a = "He said, \"Don't\""
  local b = 'He said, "Don\'t"'
  assert_equal(__(true), a == b)
end

function test_double_brackets_to_handle_really_hard_cases()
  local a = [[double-brackets can handle both ' and " characters]]
  assert_equal(__([[double-brackets can handle both ' and " characters]]), a)
end

function test_string_len()
  local str = "Hello"
  assert_equal(__(5), string.len(str))
end

function test_shorter_string_len()
  local str = "Hello"
  assert_equal(__(5), str:len())
end

function test_shorter_len_requires_extra_parenthesis_around_literals()
  assert_equal(__(5), ("Hello"):len())
end

function test_string_length_operator()
  local str = "Hello"
  assert_equal(__(5), #str)
end

function test_length_operator_does_not_require_extra_parenthesis_around_literals()
  assert_equal(__(5), #"Hello")
end

function test_double_brackets_can_handle_multiple_lines()
  local long_str = [[
It was the best of times,
It was the worst of times.
]]
  assert_equal(__(53), #long_str)
end

function test_dot_dot_will_concatenate_two_strings()
  local str = "Hello, " .. "World"
  assert_equal(__("Hello, World"), str)
end

function test_concatenation_will_leave_the_original_strings_unmodified()
  local hi = "Hello, "
  local there = "World"
  local str = hi .. there
  assert_equal(__("Hello, "), hi)
  assert_equal(__("World"), there)
end

function test_double_quoted_str_interpret_escape_characters()
  local str = "\n"
  assert_equal(__(1), #str)
end

function test_single_quoted_str_interpret_escape_characters()
  local str = '\n'
  assert_equal(__(1), #str)
end

