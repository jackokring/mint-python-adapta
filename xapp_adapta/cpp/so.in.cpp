#include "so.hpp"
#include <libintl.h>
// python version replaced by./build.sh script
#include <lua5.1/lauxlib.h>
#include <lua5.1/lua.h>
#include <lua5.1/lua.hpp>
#include <lua5.1/lualib.h>
#include <python3.12/Python.h>

// main lua instance state
lua_State *L;

PyObject *hello(PyObject *, PyObject *) {
  L = luaL_newstate();
  luaL_openlibs(L);
  // load init.lua file
  if (luaL_dostring(L, "require(\"init\")")) {
    // error
    printf("%s", lua_tostring(L, -1));
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
