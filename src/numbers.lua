function test_number_conversion()
  local str = "123"
  assert_equal(__(148), tonumber(str) + 25)
end

function test_coercion_works_on_aritmetic_operators_with_numbers()
  assert_equal(__(1024), 1000 + "24")
  assert_equal(__(2048), "1024" * 2)
  assert_equal(__(32), "64" / 2)
  assert_equal(__(256), "2" ^ 8)

  -- So these are another 2 ways of converting to number:
  assert_equal(__(20), "20" * 1)
  assert_equal(__(20), "20" + 0)
  -- ... but your code will be cleaner if you are just explicit about your conversions
end

function test_equals_sign_returns_true_for_equal_values()
  assert_equal(__(true), 1 == 1)
  assert_equal(__(false), 1 == 2)
end

function test_not_equals_sign_returns_true_for_not_equal_values()
  assert_equal(__(true),  1 ~= 2)
  assert_equal(__(false), 1 ~= 1)
end

function test_coercion_does_not_work_on_other_operators()
  assert_equal(__(false), "100" == 100)
  assert_equal(__(true), "100" ~= 100)
end

function test_division_is_always_decimal()
  assert_equal(__(3.5), 7 / 2)
end

function test_there_is_a_table_called_math()
  assert_equal(__('table'), type(math))
end

function test_some_math_functions()
  assert_equal(__(8), math.sqrt(64))
  assert_equal(__(3), math.floor(math.pi))
  assert_equal(__(-1), math.cos(math.pi))
  assert_equal(__(20), math.abs(-20))
  assert_equal(__(1), math.max(-10, -20, 1))

-- List of all math functions:

-- math.abs     math.acos    math.asin       math.atan    math.atan2
-- math.ceil    math.cos     math.cosh       math.deg     math.exp
-- math.floor   math.fmod    math.frexp      math.ldexp   math.log
-- math.log10   math.max     math.min        math.modf    math.pow
-- math.rad     math.random  math.randomseed math.sin     math.sinh
-- math.sqrt    math.tan     math.tanh

-- Interestingly enough, there's no math.round
end

function test_infinite_is_equal_to_math_huge()
  local infinite = 1/0
  assert_equal(__(true), infinite == math.huge)
end

function test_nan_is_the_only_number_not_equal_to_itself()
  local nan = 0/0
  -- '~=' is the 'not equal' sign
  assert_equal(__(true), nan ~= nan)

  -- another way of obtaining nan is math.sqrt(-1)
end
