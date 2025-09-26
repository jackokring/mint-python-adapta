#include "so.hpp"
#include <libintl.h>
// python version replaced by./build.sh script
#include <lua5.1/lauxlib.h>
// avoid the namespace capture from "C" in a { ... }
#include <lua5.1/lua.h>
// #include <lua5.1/lua.hpp>
#include <lua5.1/lualib.h>
#include <python3.12/Python.h>
// assert message
#define assertm(exp, msg) assert((void(msg), exp))

// sgn
template <typename T> int sgn(T val) { return (T(0) < val) - (val < T(0)); }

// cosine, sine quartic
static int csq(lua_State *L) {
  // unitary -1 .. 1 is -PI/2 .. PI/2
  float x = (float)luaL_checknumber(L, 1) * 2.0f / float(M_PI);
  // quadratic gain of 1, flex for shaping
  float a = (float)luaL_optnumber(L, 2, 1.0f) / 2.0f;
  // quartic gain of 1 flex for edge shaping
  float b = (float)luaL_optnumber(L, 3, 1.0f) / 24.0f;
  lua_pop(L, 3); // just in case stack under high pressure
  float x2 = x * x;
  float c = 1.0 - a * x2;
  x2 *= x2;
  c += b * x2;
  float s = 1.0 - c * c;
  int i = sgn(s);
  s = fsqrt(fabs(s)) * sgn(x) * i;
  lua_pushnumber(L, c);
  lua_pushnumber(L, s);
  // return cos, sin
  return 2;
}

//=============================================================================
// call user data
static int call(lua_State *L) {
  void *ud = luaL_checkudata(L, -1, "name"); // name?
  // apparently this next one is an unexpected test missing mem???
  luaL_argcheck(L, ud != NULL, -1, "`name' expected");
  return 0;
}
// meta functions for a userdata
static const luaL_reg meta[] = {{"__call", call}, {NULL, NULL}};

// make a new class with CFunctions
void make_meta(lua_State *L, const char *meta_name, const luaL_reg *m) {
  // the meta table
  luaL_newmetatable(L, meta_name);
  luaL_openlib(L, NULL, m, 0);
  lua_pushvalue(L, -1);
  lua_setfield(L, -2, "__index"); // for userdata method not found
  lua_setmetatable(L, -2);        // so has own actions (__index loop?)
}

//============================================================================
// main lua instance state
lua_State *L;
static const luaL_reg so_lua[] = {{"csq", csq}, {NULL, NULL}};

void add_lua_CFunctions(lua_State *L) {
  // ADD EXTRA HERE BEFDRE RETURN
  lua_getglobal(L, "_G");
  // luaL_openlib depricated NULL implies top of stack used as table
  luaL_register(L, NULL, so_lua);
}

//=============================================================================
// SPECIFIC HELLO FOR xapp_adapta BUT IS A GENERAL PYTHON LIB
// output *name(self, args) { ... }
PyObject *hello(PyObject *, PyObject *) {
  // fail on NULL
  assertm(L = luaL_newstate(), "Lua out of memory\n");
  // surprisingly not sure how this fails out of memory
  // maybe it's optimized as a bit flag extra table search?
  luaL_openlibs(L);
  // better to have the functions included here
  add_lua_CFunctions(L);
  lua_pop(L, 1);
  // typing.lua has templates for type annotations
  // so need if not _G.xxx then ... end guards
  // as include from init.lua would overwrite otherwise
  // load init.lua file
  luaL_dostring(L, "require(\"init\")");
  // even on error works
  while (lua_gettop(L) > 0) {
    const char *s = lua_tostring(L, -1);
    if (s == NULL) {
      s = ""; // almost getting error when not number or string
    }
    printf("%s\n", s);
    // pop one error message AFTER string use
    lua_pop(L, 1);
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
  bindtextdomain("_LOCALE", NULL);
  textdomain("_LOCALE");
  // ummm ... PyObjectSetAttrString in multi-create threading?
  return PyModule_Create(&so_module);
}

//=============================================================================
// maybe a direct lua loader for some
// MAKES IT SLIGHTLY MORE USEFUL
// loads as global overrides not a module
int luaopen_so(lua_State *L) {
  add_lua_CFunctions(L);
  return 1; // globally added
}
