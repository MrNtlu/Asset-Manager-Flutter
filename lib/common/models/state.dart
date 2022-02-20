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
  disposed
}

enum DetailState {
  view,
  loading,
  disposed,
}

enum CreateState {
  init,
  editing,
  loading,
  success,
  disposed
}

enum EditState {
  init,
  view,
  editing,
  loading,
  disposed
}