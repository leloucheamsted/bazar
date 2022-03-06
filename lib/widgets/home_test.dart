import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'homview_model.dart';

class HomeTest extends StatefulWidget {
  const HomeTest({Key? key}) : super(key: key);

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  // final locator = GetIt.instance;
  // final feedViewModel = GetIt.instance<FeedViewModel>();
  // @override
  // void initState() {
  //   setState(() {
  //     feedViewModel.loadVideo(0);
  //     feedViewModel.loadVideo(1);
  //   });
  //   feedViewModel.loadVideo(0);
  //   feedViewModel.loadVideo(1);

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Text(model.title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: model.updateCounter,
        ),
      ),
    );
  }
}
