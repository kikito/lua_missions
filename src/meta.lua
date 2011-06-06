function test_metatables_are_just_regular_tables()
  local t = { 1, 2, 3 }
  local mt = {}
  setmetatable(t, mt)

  assert_equal(__(true), mt == getmetatable(t))
end

function test_setmetatable_returns_the_table_being_modified()
  local mt = {}
  local t = setmetatable({1, 2, 3}, mt) -- this is a very comon idiom
  assert_equal(__(true), mt == getmetatable(t))
end

function test__tostring_metamethod_allows_defining_the_way_tables_are_transformed_into_text()
  local mt = {
    __tostring = function(x)
      return "table with " .. tostring(#x) .. " items"
    end
  }
  local t = setmetatable({1,2,3,4}, mt)
  assert_equal(__('table with 4 items'), tostring(t))
end

function test__add_metamethod_is_invoked_when_the_plus_symbol_is_used()
  local mt = {
    __add = function(a,b)
      return a.value + b.value
    end
  }

  local t1 = {value = 10}
  local t2 = {value = 20}
  setmetatable(t1, mt) -- it's enough if one of the tables has a metatable with __add

  assert_equal(__(30), t1 + t2)

  -- other metamethods like __sub, __mul, __div, __mod and __pow are very similar to __add
end

function test__unm_metamethod_is_invoked_when_the_unary_minus_symbol_is_used()
  local mt = {
    __unm = function(x)
      local result = {}
      for i=#x, 1, -1 do -- reverse loop
        table.insert(result, x[i])
      end
      return result
    end
  }

  local t = {1,2,3,4,5}
  setmetatable(t, mt)
  local result = -t

  assert_equal(__('5, 4, 3, 2, 1'), table.concat(result, ', '))
end

function test__concat__metamethod_is_invoked_when_dot_dot_operator_is_used()
  local mt = {
    __concat = function(a,b)
      local result = {}
      for i=1, #a do table.insert(result, a[i]) end
      for i=1, #b do table.insert(result, b[i]) end
      return result
    end
  }

  local t1 = {1,2,3}
  local t2 = {4,5,6}
  setmetatable(t1, mt)

  local result = t1 .. t2

  assert_equal(__('1, 2, 3, 4, 5, 6'), table.concat(result, ', '))
end

function test__eq_operator_is_invoked_when_the_equal_or_not_equal_operators_are_used()

  local t1 = {1,2,3}
  local t2 = {1,2,3}

  assert_equal(__(false), t1 == t2)
  assert_equal(__(true), t1 ~= t2)

  local mt = {
    __eq = function(a,b)
      for k,v in pairs(a) do
        if b[k] ~= v then return false end
      end
      for k,v in pairs(b) do
        if a[k] ~= v then return false end
      end
      return true
    end
  }

  setmetatable(t1, mt)
  assert_equal(__(false), t1 == t2)
  assert_equal(__(true), t1 ~= t2)

  -- only works when both tables have the same metatable
  setmetatable(t2, mt)
  assert_equal(__(true), t1 == t2)
  assert_equal(__(false), t1 ~= t2)

end

function test__lt_metamethod_is_invoked_when_the_less_or_greater_than_operators_are_used()

  local mt = {
    __lt = function(a,b)
      for i=1, #b do table.insert(a, b[i]) end
    end
  }

  local t1 = { 1,2,3 }
  local t2 = { 4,5,6 }

  -- as before, this only works if both tables have the same metatable
  setmetatable(t1, mt)
  setmetatable(t2, mt)

  -- we are using the < operator for addition, we can discard the result
  _ = t1 < t2

  assert_equal(__('1, 2, 3, 4, 5, 6'), table.concat(t1, ', '))

  -- there's also a __le that works similarly to lt, but for the <= operator
end

function test__call_operator_is_invoked_when_a_table_is_used_like_a_function()
  local doubler = setmetatable({}, {
    __call = function(t, x)
      return x * 2
    end
  })

  assert_equal(__(20), doubler(10))
end
