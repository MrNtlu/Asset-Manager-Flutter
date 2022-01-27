extension RevertDouble on double {
  double revertValue() {
    return this < 0 ? abs() : this * -1;
  }
}