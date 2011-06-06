function test__index_metamethod_is_invoked_when_a_key_is_not_found_on_table()

  local mt = {
    __index = function(tbl,key)
      return tostring(key) .. " not found on t"
    end
  }

  local t = setmetatable({x = 1, y = 2}, mt)

  assert_equal(__(1), t.x)
  assert_equal(__('z not found on t'), t.z)
end

function test__index_metamethod_can_be_used_to_look_up_values_in_other_tables()
  local t1 = {z = 3}

  local mt = {
    __index = function(tbl,key)
      return t1[key]
    end
  }

  local t2 = setmetatable({x = 1, y = 2}, mt)

  assert_equal(__(3), t2.z)
end

function test_syntactic_sugar_when__index_metamethod_is_assigned_to_a_table()
  local t1 = {z = 3}
  local mt = { __index = t1 }
  local t2 = setmetatable({x = 1, y = 2}, mt)

  assert_equal(__(3), t2.z)
end

function test__syntactic_sugar_allows_for_one_liners()
  local t2 = setmetatable({x = 1, y = 2}, { __index = {z = 3} })
  assert_equal(__(3), t2.z)
end

function test_rawget_does_not_invoke__index_metamethod()

  local t2 = setmetatable({x = 1, y = 2}, { __index = {z = 3} })
  -- rawget is useful to avoid infinite recursions, or when you just want to bypass the metatable
  -- it usually returns nil
  assert_equal(__(nil), rawget(t2, 'z'))
  -- question: how can you make an infinite recursion happen with metatables and __index?
end

function test__index_also_works_on_integer_keys()
  local doubler = setmetatable({}, { __index = function (t, key) return key * 2 end })
  assert_equal(__(48), doubler[24]) 
end

function test__newindex_metamethod_is_invoked_when_a_new_value_is_inserted_in_a_table()
  
  local t1 = {}
  
  local t2 = setmetatable({}, { 
    __newindex = function(t, key, value)
      t1[key] = value * 10
    end
  })
  t2.x = 1
  assert_equal(__(nil), t2.x)
  assert_equal(__(10), t1.x)
end

function test__newindex_syntactic_sugar_for_tables()
  local t1 = {}
  local t2 = setmetatable({}, { __newindex = t1 })

  t2.x = 10
  assert_equal(__(nil), t2.x)
  assert_equal(__(10), t1.x)
end

function test__rawset_allows_modifying_tables_without_invoking_newindex()
  
  local clock = setmetatable({}, { 
    __newindex = function(t, key, value)
      if key == 'hours' then
        rawset(t, 'seconds', value * 3600)
      elseif key == 'minutes' then
        rawset(t, 'seconds', value * 60)
      elseif key == 'seconds' then
        rawset(t, 'seconds', value)
      end
      -- else the value is ignored
    end
  })

  clock.hours = 2.5
  assert_equal(__(9000), clock.seconds)

  clock.minutes = 20
  assert_equal(__(1200), clock.seconds)

  clock.seconds = 15
  assert_equal(__(15), clock.seconds)

  clock.foo = 'hi'
  assert_equal(__(nil), clock.foo)

end
