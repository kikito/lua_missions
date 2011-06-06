--[[
  EXERCISE 1: Monkey-patching strings

  With all you have learnt now, you should be able to do this exercise

  Add the necessary code below so that the test at the end passes

]]

-- INSERT YOUR CODE HERE


-- END OF CODE INSERT

function test_new_string_functions()
  local str = "Lua is awesome"

  assert_true(str:starts_with("L"))
  assert_true(str:starts_with("Lua"))
  assert_true(str:starts_with("Lua is"))

  assert_true(str:ends_with("e"))
  assert_true(str:ends_with("some"))
  assert_true(str:ends_with("awesome"))
end

-- hint: string == getmetatable("").__index








