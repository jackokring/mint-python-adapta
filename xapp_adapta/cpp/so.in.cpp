#include "so.hpp"
#include <libintl.h>
// python version replaced by./build.sh script
#include <lua5.1/lauxlib.h>
// avoid the namespace capture from "C" in a { ... }
#include <lua5.1/lua.h>
// #include <lua5.1/lua.hpp>
#include <lua5.1/lualib.h>
#include <python3.12/Python.h>

// sgn
template <typename T> int sgn(T val) { return (T(0) < val) - (val < T(0)); }

// cosine, sine quartic
static int csq(lua_State *L) {
  if (lua_gettop(L) < 3) {
    lua_pushstring(L, "needs unitary angle, quadgain and quartgain arguments");
    lua_error(L);
  }
  // unitary -1 .. 1 is -PI/2 .. PI/2
  float x = (float)luaL_checknumber(L, -3) * 2.0f / float(M_PI);
  // quadratic gain of 1, flex for shaping
  float a = (float)luaL_checknumber(L, -2) / 2.0f;
  // quartic gain of 1 flex for edge shaping
  float b = (float)luaL_checknumber(L, -1) / 24.0f;
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

void add_lua_CFunctions_local(lua_State *L, const luaL_reg *p) {
  while ((*p).name != NULL) {
    lua_pushcfunction(L, (*p).func);
    lua_setfield(L, -2, (*p).name);
    p++;
  }
}
// make a new class with CFunctions
void make_class(lua_State *L, const char *name, const luaL_reg *m,
                const luaL_reg *c) {
  // the class table
  lua_newtable(L);
  add_lua_CFunctions_local(L, c);
  lua_pushvalue(L, -1);
  lua_setfield(L, -2, "__index"); // for instance method not found
  // the meta table
  lua_newtable(L);
  add_lua_CFunctions_local(L, m);
  lua_setmetatable(L, -2); // so has own actions (__index loop?)
  lua_setglobal(L, name);
}

static int new_instance(lua_State *L) {
  if (lua_gettop(L) != 1) {
    lua_pushstring(L, "no class");
    lua_error(L);
  }
  lua_newtable(L);      // instance
  lua_pushvalue(L, -2); // class named
  lua_setmetatable(L, -2);
  return 1; // does drop
}

// meta functions for a class class "instance"
static const luaL_reg meta[] = {{"__call", new_instance}, {NULL, NULL}};
// class functions for an instance of such
// __call works to make class instance a class also (prototype)
// __call not found so __index
static const luaL_reg clazz[] = {/*{"__call", new_instance},*/ {NULL, NULL}};

//============================================================================
// main lua instance state
lua_State *L;
static const luaL_reg so_lua[] = {{"csq", csq}, {NULL, NULL}};

void add_lua_CFunctions(lua_State *L) {
  auto p = so_lua;
  while ((*p).name != NULL) {
    lua_register(L, (*p).name, (*p).func);
    p++;
  }
  make_class(L, "Nad", meta, clazz);
}

//=============================================================================
// SPECIFIC HELLO FOR xapp_adapta BUT IS A GENERAL PYTHON LIB
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
    add_lua_CFunctions(L);
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
  return 0; // globally added
}
