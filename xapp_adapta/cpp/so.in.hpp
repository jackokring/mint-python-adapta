#pragma once
#include "Python.h"
#include <libintl.h>

#define _(String) gettext(String)

PyObject *hello(PyObject *, PyObject *);

static PyMethodDef so_methods[] = {{"hello", (PyCFunction)hello, METH_NOARGS},
                                   {nullptr, nullptr, 0, nullptr}};

static PyModuleDef so_module = {PyModuleDef_HEAD_INIT, "so", "C++ .so", -1,
                                so_methods};

PyMODINIT_FUNC PyInit_so(void) {
  Py_Initialize();
  bindtextdomain("LOCALE", NULL);
  textdomain("LOCALE");
  return PyModule_Create(&so_module);
}
