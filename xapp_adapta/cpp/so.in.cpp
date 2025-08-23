#include "so.hpp"
#include <libintl.h>
// python version replaced by./build.sh script
#include <python3.12/Python.h>

PyObject *hello(PyObject *, PyObject *) {
  return PyUnicode_FromString(_("A string"));
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
