import 'package:get_it/get_it.dart';

import 'Services/feef_videoModel.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerSingleton<FeedViewModel>(FeedViewModel());
}
