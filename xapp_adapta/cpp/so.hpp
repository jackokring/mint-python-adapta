#pragma once
#include "Python.h"

PyObject *hello(PyObject *, PyObject *);

static PyMethodDef extension_methods[] = {
    {"hello", (PyCFunction)hello, METH_NOARGS}, {nullptr, nullptr, 0, nullptr}};

static PyModuleDef extension_module = {PyModuleDef_HEAD_INIT, "so",
                                       "C++ Extensions", -1, extension_methods};

PyMODINIT_FUNC PyInit_so(void) {
  Py_Initialize();
  return PyModule_Create(&extension_module);
}
