function test_creating_empty_tables()
  local empty_table = {}
  assert_equal( __, type(empty_table))
end

function test_empty_tables_return_nil_when_indexed()
  local empty_table = {}
  assert_equal( __, empty_table[1])
end

function test_table_modifications()
  local t = {}
  t[1] = 1
  assert_equal(__, t[1])

  t[2] = 2
  assert_equal(__, t[2])

  t[3] = 'a'
  assert_equal(__, t[3])

  assert_equal(__, t[4])
end

function test_inline_table_literals()
  local t = { 1, 2, 'a' }
  assert_equal(__, t[1])
  assert_equal(__, t[2])
  assert_equal(__, t[3])
end

function test_tables_inside_tables()
  local t = { { 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 } }
  assert_equal(__, t[2][3])
end

function test_tables_are_references_not_values()
  local a = { 1, 2, 3 }
  local b = { 1, 2, 3 }
  local c = a
  assert_equal(__, a == b)
  assert_equal(__, a == c)
end

function test_table_concat()
  local t = { 'one', 'two', 'three' }
  assert_equal(__, table.concat(t))
  assert_equal( __, table.concat(t, ', ') )
end

function test_table_length()
  local a = { 1, 2, 3 }
  assert_equal( __, #a)
end

function test_the_default_table_table()
  -- there's a table called "table". It has functions for table manipulation inside
  assert_equal( __, type(table))
end

function test_table_insert()
  local a = { 1, 2 }
  table.insert(a, 3)
  assert_equal(__, table.concat(a, ', '))
end

function test_table_insert_with_position()
  local a = { 'a', 'c' }
  table.insert(a, 2, 'b')
  assert_equal(__, table.concat(a, ', '))
end

function test_table_remove()
  local a = { 1, 2, 3, 'last' }
  table.remove(a)
  assert_equal(__, table.concat(a, ', '))
end

function test_table_remove_with_position()
  local a = { 'a', 'b', 'foo', 'c' }
  table.remove(a, 3)
  assert_equal(__, table.concat(a, ', '))
end

function test_table_sort()
  local x = { 5, 3, 25, 1 }
  table.sort(x)
  assert_equal(__, table.concat(x, ', '))
end

function test_table_sort_with_function()
  local x = { 5, 3, 25, 1 }
  table.sort(x, function(a, b) return a > b end)
  assert_equal(__, table.concat(x, ', '))
end
