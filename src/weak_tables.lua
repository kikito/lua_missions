
-- note: the garbage collector can be explicitly invoked with collectgarbage

function test_gc_does_not_remove_values_from_regular_tables_with_references()
  local t = {}
  t.foo = {}
  collectgarbage()
  assert_equal(__('table'), type(t.foo))
end

function test_gc_removes_values_from_tables_with__mode_set_to_v_if_there_are_no_other_references_to_them()
  local t = setmetatable({}, { __mode = 'v' })
  t.foo = {}
  collectgarbage()
  assert_equal(__('nil'), type(t.foo))
end

function test_gc_does_not_remove_values_from_tables_with__mode_set_to_v_if_there_are_other_references()
  local t = setmetatable({}, { __mode = 'v' })
  local x = {}
  t.foo = x
  collectgarbage()
  assert_equal(__('table'), type(t.foo))
end

function test_gc_does_not_remove_keys_from_regular_tables()
  local t = {}
  local x = {}
  t[x] = true
  collectgarbage()
  assert_equal(__(true), t[x])
end

-- not a test, a helper
local function has_anything(t)
  for k,v in pairs(t) do
    return true
  end
  return false
end

function test_gc_does_not_remove_the_key_when__mode_is_k_and_there_are_other_references_to_it()
  local t = setmetatable({}, { __mode = 'k' })
  local x = {}
  t[x] = true
  collectgarbage()
  assert_equal(__(true), has_anything(t))
end

function test_gc_removes_the_key_when__mode_is_k_and_no_other_references_remain()
  local t = setmetatable({}, { __mode = 'k' })
  do
    local x = {}
    t[x] = true
  end
  collectgarbage()
  assert_equal(__(false), has_anything(t))
end

function test_really_weak_tables_have_their_mode_set_to_both_k_and_v()
  local t = setmetatable({}, { __mode = 'kv' })
  do
    local x = {}
    t[x] = x
  end
  assert_equal(__(true), has_anything(t))
  collectgarbage()
  assert_equal(__(false), has_anything(t))
end







