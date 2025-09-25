#include "so.hpp"
#include <libintl.h>
// python version replaced by./build.sh script
#include <lua5.1/lauxlib.h>
// avoid the namespace capture from "C" in a { ... }
#include <lua5.1/lua.h>
// #include <lua5.1/lua.hpp>
#include <lua5.1/lualib.h>
#include <python3.12/Python.h>

// cosine, sine quartic
static int csq(lua_State *L) {
  if (lua_gettop(L) < 3) {
    lua_pushstring(L, "needs unitary angle, quadgain and quartgain arguments");
    lua_error(L);
  }
  // unitary -1 .. 1 is -PI/2 .. PI/2
  float x = (float)luaL_checknumber(L, -3) * 2.0 / M_PI;
  // quadratic gain of 1, flex for shaping
  float a = (float)luaL_checknumber(L, -2) / 2.0;
  // quartic gain of 1 flex for edge shaping
  float b = (float)luaL_checknumber(L, -1) / 24.0;
  float x2 = x * x;
  float c = 1.0 - a * x2;
  x2 *= x2;
  c += b * x2;
  float s = fsqrt(1.0 - c * c);
  lua_pushnumber(L, c);
  lua_pushnumber(L, s);
  // return cos, sin
  return 2;
}

// main lua instance state
lua_State *L;

void add_lua_CFunctions() {
  // all CFunctions must be C static global scope
  // static int foo(lua_State *L) { ... } // for example
  static const char *names[] = {"csq", NULL}; // NULL TERMINATE!!
  static const lua_CFunction fpointers[] = {csq};
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

// some stuff about .m_size and multithreading thread local storage
static PyModuleDef so_module = {PyModuleDef_HEAD_INIT, "so", "C++ .so", -1,
                                so_methods};

PyMODINIT_FUNC PyInit_so(void) {
  Py_Initialize();
  // ./build.sh replaces locale to correct domain making so.cpp
  bindtextdomain("com.github.jackokring.xapp_adapta", NULL);
  textdomain("com.github.jackokring.xapp_adapta");
  // ummm ... PyObjectSetAttrString in multi-create threading?
  return PyModule_Create(&so_module);
}
