function loadstring_executes_lua_code_inside_a_string_by_creating_a_function()
  local f = loadstring("return 1 + 1")
  assert_equal(__(2), f())
end

function loadstring_does_not_have_access_to_the_scope_where_it_is_invoked()
  local value = 10
  local f = loadstring("return value")
  assert_equal(__(nil), f())
  -- loadstring always uses the global scope.
end

function loadstring_can_use_local_variables_declared_inside_the_string()
  local f = loadstring("local x = 10; return x + 1")
  assert_equal(__(11), f())
end

function loadstring_returns_nil_plus_an_error_message_if_there_is_a_syntax_error()
  local value = 10
  local status, message = loadstring("if true return 'hello' end")
  assert_equal(__(nil), status)
  assert_equal(__([[[string "if true return 'hello' end"]:1: 'then' expected near 'return']]), message)
end

function loadstring_never_raises_errors_when_called_but_its_generated_function_can_raise_them()
  local f = loadstring("error('hello', 0)")

  assert_equal(__('function'), type(f))

  local status, message = pcall(f)

  assert_equal(__(false), status)
  assert_equal(__('hello'), message)
end

function loadfile_works_like_loadstring_but_it_uses_a_path_and_reads_from_a_file()
  local f = loadfile("test_file.lua")
  assert_equal(__('function'), type(f))

  local person = f()
  assert_equal(__('kikito'), person.id)
  assert_equal(__('hello there!'), person.speak())
end

function dofile_loads_the_file_and_executes_the_function_directly()
  local person = dofile("test_file.lua")
  assert_equal(__('kikito'), person.id)
  assert_equal(__('hello there!'), person.speak())
  -- it also raises errors if the file isn't found, the path doesn't exist, etc
end

function package_path_is_a_string_containing_question_mark_dot_lua()
  assert_equal(__('string'), type(package.path))
  assert_equal(__(true), package.path:find('?.lua') ~= nil)
end

function require_is_like_do_file_but_it_uses_package_path_so_it_doesnt_need_dot_lua_at_the_end_of_path()
  local person = require("test_file")
  assert_equal(__('kikito'), person.id)
  assert_equal(__('hello there!'), person.speak())
  --.note that you can modify package.path so that the files are correctly loaded
end

function require_loads_the_file_only_once_caching_the_results()
  local person1 = dofile("test_file.lua")
  local person2 = require("test_file")
  local person3 = require("test_file")

  assert_equal(__(false), person1 == person2)
  assert_equal(__(true),  person2 == person3)
end

-- for all this, require is the Prefered Lua Way for requiring files






