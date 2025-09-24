#include "so.hpp"
#include <libintl.h>
// python version replaced by./build.sh script
#include <lua5.1/lauxlib.h>
// avoid the namespace capture from "C" in a { ... }
#include <lua5.1/lua.h>
// #include <lua5.1/lua.hpp>
#include <lua5.1/lualib.h>
#include <python3.12/Python.h>

// main lua instance state
lua_State *L;

void add_lua_CFunctions() {
  // all CFunctions must be C static global scope
  // static int foo(lua_State *L) { ... } // for example
  static const char *names[] = {NULL}; // NULL TERMINATE!!
  static const lua_CFunction fpointers[] = {};
  auto p = names;
  auto f = fpointers;
  while (*p != NULL) {
    lua_register(L, *p++, *f++);
  }
}

// output *name(self, args) { ... }
PyObject *hello(PyObject *, PyObject *) {
  if ((L = luaL_newstate()) == NULL) {
    printf("Lua out of memory");
  } else {
    // surprisingly not sure how this fails out of memory
    // maybe it's optimized as a bit flag extra table search?
    luaL_openlibs(L);
    // load init.lua file
    if (luaL_dostring(L, "require(\"init\")")) {
      // error as -1 from top (zero is empty), +ve are from frame pointer
      printf("%s", lua_tostring(L, -1));
      // pop one error message AFTER string use
      lua_pop(L, 1);
    }
    add_lua_CFunctions();
  }
  return PyUnicode_FromString(_("C++ module loaded"));
}

static PyMethodDef so_methods[] = {{"hello", (PyCFunction)hello, METH_NOARGS},
                                   {nullptr, nullptr, 0, nullptr}};

static PyModuleDef so_module = {PyModuleDef_HEAD_INIT, "so", "C++ .so", -1,
                                so_methods};

PyMODINIT_FUNC PyInit_so(void) {
  Py_Initialize();
  // ./build.sh replaces locale to correct domain making so.cpp
  bindtextdomain("_LOCALE", NULL);
  textdomain("_LOCALE");
  return PyModule_Create(&so_module);
}
