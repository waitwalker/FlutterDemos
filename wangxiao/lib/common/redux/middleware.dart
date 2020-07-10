import 'package:redux/redux.dart';

import 'app_state.dart';

// functional
loggingMiddleware(Store<AppState> store, action, NextDispatcher next) {
  next(action);
}
