import 'package:pedometer/pedometer.dart';

late Stream<StepCount> _stepCountStream;
late Stream<PedestrianStatus> _pedestrianStatusStream;

void onStepCount(StepCount event) {
  /// Handle step count changed
  int steps = event.steps;
  DateTime timeStamp = event.timeStamp;
}

void onPedestrianStatusChanged(PedestrianStatus event) {
  /// Handle status changed
  String status = event.status;
  DateTime timeStamp = event.timeStamp;
}

void onPedestrianStatusError(error) {
  /// Handle the error
}

void onStepCountError(error) {
  /// Handle the error
}

Future<void> initPlatformState() async {
  /// Init streams
  _pedestrianStatusStream = await Pedometer.pedestrianStatusStream;
  _stepCountStream = await Pedometer.stepCountStream;

  /// Listen to streams and handle errors
  _stepCountStream.listen(onStepCount).onError(onStepCountError);
  _pedestrianStatusStream
      .listen(onPedestrianStatusChanged)
      .onError(onPedestrianStatusError);
}
