-- patterns are Lua's version of regular expressions

function test_string_find_returns_nil_if_pattern_not_matched()
  local str = 'banana'
  local pattern = 'lalala'
  assert_equal(__(nil), string.find(str, pattern))
end

function test_string_find_a_pattern()
  local str = 'banana'
  local pattern = 'an'
  local start_pos, end_pos = string.find(str, pattern)
  assert_equal(__(2), start_pos)
  assert_equal(__(3), end_pos)
end

function test_string_find_a_pattern_with_starting_position()
  local str = 'banana'
  local pattern = 'an'
  local start_pos, end_pos = string.find(str, pattern, 4)
  assert_equal(__(4), start_pos)
  assert_equal(__(5), end_pos)
end

function test_dots_are_interpreted_as_any_char()
  local str = 'banana'
  local pattern = 'a...'
  local start_pos, end_pos = string.find(str, pattern)
  assert_equal(__(2), start_pos)
  assert_equal(__(5), end_pos)
end

function test_dots_are_not_interpreted_as_any_char_if_param_4_is_true()
  local str = 'banana'
  local pattern = 'a...'
  local start_pos, end_pos = string.find(str, pattern, 1, true)
  assert_equal(__(nil), start_pos)
end

-- this is not a test, but a helper local function
local function find(str, pattern, start)
  return string.sub(str, string.find(str, pattern, start))
end

function test_find_helper()
  assert_equal(__('waldo'), find('find waldo on this phrase', 'w....'))
end

function test_character_classes()
  local letter      = '%a'
  local digit       = '%d'
  local lower       = '%l'
  local upper       = '%u'
  local percent     = '%%'

  assert_equal(__('m'), find('1 4m 1337', letter))
  assert_equal(__('2'), find('This is the 2nd example', digit))
  assert_equal(__('l'), find('UPPER lower', lower))
  assert_equal(__('U'), find('UPPER lower', upper))
  assert_equal(__('%'), find('100% escaped', percent))

  -- other character classes:
  -- %c matches any control character
  -- %x matches any hexadecimal character
  -- %w alphanumeric
end

function test_character_sets()
  local str = "This is my phrase"
  local pattern = "[xz1p]"
  assert_equal(__('p'), find(str, pattern))
end

function test_negated_character_sets()
  local str = "This is my phrase"
  local pattern = "[^This ]"
  assert_equal(__('m'), find(str, pattern))
end

function test_character_ranges()
  local str = "a time of wonder"
  local pattern = "[d-f]"
  assert_equal(__('e'), find(str, pattern))
end

function test_negated_character_ranges()
  local str = "a time of wonder"
  local pattern = "[^a-z]"
  assert_equal(__(' '), find(str, pattern))
end

function test_zero_or_more()
  assert_equal(__('a'), find('I am at your service', 'ax*'))
end

function test_one_or_more()
  assert_equal(__('1979'), find('I think 1979 was a great year', '%d+'))
end

function test_one_or_none()
  assert_equal(__('i'), find('Pattern matching is amazing', 'is?'))
end

function test_string_find_with_one_capture()
  local str = "Today's word is: eclectic"
  local pattern = ": (.+)"
  local start_pos, end_pos, match = string.find(str, pattern)
  assert_equal(__('eclectic'), match)
end

function test_string_find_with_several_captures()
  local str = "Today's word is: eclectic"
  local pattern = "(w%a+).*: (.+)"
  local _, _, match1, match2 = string.find(str, pattern)
  assert_equal(__('word'), match1)
  assert_equal(__('eclectic'), match2)
end

function test_string_find_nested_captures()
  local str = "Today's word is: eclectic"
  local pattern = ": (..(.+)..)"
  local _, _, match1, match2 = string.find(str, pattern)
  assert_equal(__('eclectic'), match1)
  assert_equal(__('lect'), match2)
end

function test_string_gsub_with_a_string()
  local str = "Today's word is: eclectic"
  local pattern = "(e%a+)"
  local result = string.gsub(str, pattern, 'banana')
  assert_equal(__("Today's word is: banana"), result)
end

function test_string_gsub_with_a_function()
  local str = "Today's word is: eclectic"
  local pattern = "(e%a+)"
  local result = string.gsub(str, pattern, string.upper)
  assert_equal(__("Today's word is: ECLECTIC"), result)
end

function test_string_gsub_with_an_anonymous_function()
  local str = "Today's word is: eclectic"
  local pattern = "(e%a+)"
  local result = string.gsub(str, pattern, function(x) return '<'.. x ..'>' end)
  assert_equal(__("Today's word is: <eclectic>"), result)
end
