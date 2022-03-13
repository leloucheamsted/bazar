import 'dart:developer';

import 'package:bazar/Services/fiel_model_fire.dart';
import 'package:bazar/Services/providerModel.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

import 'Services/feef_videoModel.dart';

final locator = GetIt.instance;
final loc = GetIt.instance;
void setup() {
  locator.registerSingleton<VideoModel>(VideoModel());
}
