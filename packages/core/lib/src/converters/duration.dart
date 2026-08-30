import 'package:json_annotation/json_annotation.dart';
import 'package:time/time.dart';

class const DurationSecondsConverter() extends JsonConverter<Duration, double> {
  @override
  Duration fromJson(double json) => (json * Duration.microsecondsPerSecond).round().microseconds;

  @override
  double toJson(Duration object) => object.inMicroseconds / Duration.microsecondsPerSecond;
}

class const DurationMillisecondsConverter() extends JsonConverter<Duration, int> {
  @override
  Duration fromJson(int json) => json.milliseconds;

  @override
  int toJson(Duration object) => object.inMilliseconds;
}
