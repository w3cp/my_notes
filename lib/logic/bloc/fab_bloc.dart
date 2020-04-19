import 'dart:async';

class FabBloc {

  final fabController = StreamController<bool>();
  final fabVisibleController = StreamController<bool>();

  Sink<bool> get fabSink => fabController.sink;

  Stream<bool> get fabVisible => fabVisibleController.stream;

  FabBloc() {
    fabController.stream.listen(onScroll);
  }
  onScroll(bool visible) {
    fabVisibleController.add(visible);
  }

  void dispose() {
    fabController?.close();
    fabVisibleController?.close();
  }
}
