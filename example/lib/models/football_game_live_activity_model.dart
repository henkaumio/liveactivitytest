import 'package:live_activities/models/live_activity_image.dart';

class MomentLiveActivityModel {
  final DateTime? sleepStartDate;
  final DateTime? suggestedSleepEndDate;
  final String? momentName;
  final LiveActivityImageFromAsset? momentImage;
  final bool? paused;
  final int? counter;

  MomentLiveActivityModel({
    this.sleepStartDate,
    this.suggestedSleepEndDate,
    this.momentName,
    this.momentImage,
    this.paused,
    this.counter,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'sleepStartDate': sleepStartDate?.millisecondsSinceEpoch,
      'suggestedSleepEndDate': suggestedSleepEndDate?.millisecondsSinceEpoch,
      'momentName': momentName,
      'momentImage': momentImage,
      'paused': paused,
      'counter': counter,
    };

    return map;
  }

  MomentLiveActivityModel copyWith({
    DateTime? sleepStartDate,
    DateTime? suggestedSleepEndDate,
    String? momentName,
    LiveActivityImageFromAsset? momentImage,
    bool? paused,
    int? counter,
  }) {
    return MomentLiveActivityModel(
      sleepStartDate: sleepStartDate ?? this.sleepStartDate,
      suggestedSleepEndDate:
          suggestedSleepEndDate ?? this.suggestedSleepEndDate,
      momentName: momentName ?? this.momentName,
      momentImage: momentImage ?? this.momentImage,
      paused: paused ?? this.paused,
      counter: counter ?? this.counter,
    );
  }
}
