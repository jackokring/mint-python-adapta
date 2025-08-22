#include "so.hpp"

PyObject *hello(PyObject *, PyObject *) {
  return PyUnicode_FromString(_("A string"));
}
