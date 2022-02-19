enum ListState {
  init,
  loading,
  done,
  empty,
  error,
  paginating,
  disposed
}

enum ViewState {
  init,
  loading,
  done,
  empty,
  error,
}

enum DetailState {
  view,
  loading,
  disposed,
}

enum CreateState {
  editing,
  loading,
  success,
}

enum EditState {
  view,
  editing,
  loading
}