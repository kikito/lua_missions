function test_creating_empty_tables()
  local empty_table = {}
  assert_equal( __('table'), type(empty_table))
end

function test_empty_tables_return_nil_when_indexed()
  local empty_table = {}
  assert_equal( __(nil), empty_table[1])
end

function test_table_modifications()
  local t = {}
  t[1] = 1
  assert_equal(__(1), t[1])

  t[2] = 2
  assert_equal(__(2), t[2])

  t[3] = 'a'
  assert_equal(__('a'), t[3])

  assert_equal(__(nil), t[4])
end

function test_inline_table_literals()
  local t = { 1, 2, 'a' }
  assert_equal(__(1), t[1])
  assert_equal(__(2), t[2])
  assert_equal(__('a'), t[3])
end

function test_tables_inside_tables()
  local t = { { 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 } }
  assert_equal(__(6), t[2][3])
end

function test_tables_are_references_not_values()
  local a = { 1, 2, 3 }
  local b = { 1, 2, 3 }
  local c = a
  assert_equal(__(false), a == b)
  assert_equal(__(true), a == c)
end

function test_table_concat()
  local t = { 'one', 'two', 'three' }
  assert_equal(__('onetwothree'), table.concat(t))
end

function test_table_concat_with_separator()
  local t = { 'one', 'two', 'three' }
  assert_equal(__('one, two, three'), table.concat(t, ', ') )
end

function test_the_default_table_table()
  -- there's a table called "table". It has functions for table manipulation inside
  assert_equal( __('table'), type(table))
end

function test_table_insert()
  local a = { 1, 2 }
  table.insert(a, 3)
  assert_equal(__('1, 2, 3'), table.concat(a, ', '))
end

function test_table_insert_with_position()
  local a = { 'a', 'c' }
  table.insert(a, 2, 'b')
  assert_equal(__('a, b, c'), table.concat(a, ', '))
end

function test_table_remove()
  local a = { 1, 2, 3, 'last' }
  table.remove(a)
  assert_equal(__('1, 2, 3'), table.concat(a, ', '))
end

function test_table_remove_with_position()
  local a = { 'a', 'b', 'foo', 'c' }
  table.remove(a, 3)
  assert_equal(__('a, b, c'), table.concat(a, ', '))
end

function test_table_sort()
  local x = { 5, 3, 25, 1 }
  table.sort(x)
  assert_equal(__('1, 3, 5, 25'), table.concat(x, ', '))
end

function test_table_sort_with_function()
  local x = { 5, 3, 25, 1 }
  table.sort(x, function(a, b) return a > b end)
  assert_equal(__('25, 5, 3, 1'), table.concat(x, ', '))
end

function test_table_length()
  local a = { 1, 2, 3 }
  assert_equal( __(3), #a)
end

function test_table_length_only_takes_into_account_consecutive_numbers()
  local t = { 1, 2, 3 }
  t[1000] = 1000
  assert_equal( __(3), #t)
end

function test_using_string_as_keys()
  local t = { ['hi'] = 'hello' }
  t['you'] = 'world'
  assert_equal(__('hello'), t['hi'])
  assert_equal(__('world'), t['you'])
end

function test_nicer_ways_of_using_strings_as_keys()
  -- this is the preferred way of using strings as keys. If you need to use reserved words,
  -- or other things (functions, tables) as keys you will need to use the previous form
  local t = { hi = 'hello' }
  t.you = 'world'
  assert_equal(__('hello'), t.hi)
  assert_equal(__('world'), t.you)
end

function test_creating_an_inline_mixed_table()
  local t = { 'a', 'b', 'c', foo = 'foo' }
  assert_equal(__('a'), t[1])
  assert_equal(__('b'), t[2])
  assert_equal(__('foo'), t.foo)
end

function test_non_numberic_keys_are_ignored_by_table_length()
  local t = { 1,2, hi = 'hello' }
  assert_equal(__(2), #t)
end

function test_non_numeric_keys_are_ignored_by_table_concat()
  local t = { 1,2, hello = 'hi' }
  assert_equal(__('1, 2'), table.concat(t, ', '))
end

function test_using_tables_as_keys()
  local hi = { 1, 2, 3 }
  local you = { 4, 5, 6 } 
  local t = { [hi] = 'hello' }
  t[you] = 'world'
  assert_equal(__('hello'), t[hi])
  assert_equal(__('world'), t[you])
  assert_equal(__(nil), t[{1, 2, 3}]) -- remember: tables are treated as references
end

function test_unpacking_a_table()
  local t = { 1, 2, 3 }
  local a,b,c = unpack(t)
  assert_equal(__(1), a)
  assert_equal(__(2), b)
  assert_equal(__(3), c)
end



