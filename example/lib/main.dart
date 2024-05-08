import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities/models/live_activity_image.dart';
import 'package:live_activities/models/url_scheme_data.dart';
import 'package:live_activities_example/di_manager.dart';
import 'package:live_activities_example/models/football_game_live_activity_model.dart';
import 'package:live_activities_example/widgets/score_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _liveActivitiesPlugin = LiveActivities();
  String? _latestActivityId;
  StreamSubscription<UrlSchemeData>? urlSchemeSubscription;
  MomentLiveActivityModel? _momentLiveActivityModel;
  int currentTime = 0;

  final DynamicIslandManager diManager = DynamicIslandManager(channelKey: 'DI');

  final Stream timerStream = Stream.periodic(const Duration(seconds: 1));
  StreamSubscription? timerStreamSubscriber;

  bool paused = true; // Initially paused

  void togglePaused(bool _paused) {
    setState(() {
      paused = _paused; // Toggle the paused state
    });
    diManager.methodOne(
      jsonData: {
        'paused': _paused,
      },
    );
    _updateActivity(paused, currentTime);
  }

  @override
  void initState() {
    super.initState();
    diManager.startListening(
      onPause: () {
        togglePaused(true);
      },
      onPlay: () {
        togglePaused(false);
      },
    );
    timerStreamSubscriber = timerStream.listen((event) {
      if (!paused) {
        print('incrementing time');
        setState(() {
          currentTime += 1;
        });
        _updateActivity(paused, currentTime);
      }
    });

    _liveActivitiesPlugin.init(
        appGroupId: 'group.dimitridessus.liveactivities', urlScheme: 'la');

    _liveActivitiesPlugin.activityUpdateStream.listen((event) {
      print('Activity update: $event');
    });

    urlSchemeSubscription =
        _liveActivitiesPlugin.urlSchemeStream().listen((schemeData) {
      setState(() {
        switch (schemeData.path) {
          case '/pause':
            paused = true;
            togglePaused(true);
            break;
          case '/resume':
            togglePaused(false);
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    urlSchemeSubscription?.cancel();
    timerStreamSubscriber?.cancel();
    _liveActivitiesPlugin.dispose();
    super.dispose();
  }

  @override
  StatefulWidget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live Activities (Flutter)',
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // a line indicatting a timer that runs
              Text(
                'Timer: $currentTime',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () async {
                  print('start nap');
                  togglePaused(false);
                  _momentLiveActivityModel = MomentLiveActivityModel(
                    sleepStartDate: DateTime.now(),
                    suggestedSleepEndDate: DateTime.now().add(
                      const Duration(
                        minutes: 5,
                      ),
                    ),
                    momentName: 'Nap time 😴',
                    momentImage: LiveActivityImageFromAsset(
                      'assets/images/psg.png',
                    ),
                    paused: paused,
                    counter: currentTime,
                  );

                  final activityId = await _liveActivitiesPlugin.createActivity(
                    _momentLiveActivityModel!.toMap(),
                  );
                  setState(() => _latestActivityId = activityId);
                },
                child: const Column(
                  children: [
                    Text('Start nap'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  togglePaused(false);
                },
                child: const Column(
                  children: [
                    Text('resume nap'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  togglePaused(true);
                },
                child: const Column(
                  children: [
                    Text('pause nap'),
                  ],
                ),
              ),

              if (_latestActivityId != null)
                TextButton(
                  onPressed: () {
                    _liveActivitiesPlugin.endAllActivities();
                    _latestActivityId = null;
                    togglePaused(true);
                  },
                  child: const Column(
                    children: [
                      Text('Cancel Nap ✋'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future _updateActivity(bool paused, int counter) async {
    if (_momentLiveActivityModel == null) {
      return;
    }

    final data = _momentLiveActivityModel!.copyWith(
      sleepStartDate: _momentLiveActivityModel!.sleepStartDate,
      suggestedSleepEndDate: _momentLiveActivityModel!.suggestedSleepEndDate,
      momentName: _momentLiveActivityModel!.momentName,
      momentImage: _momentLiveActivityModel!.momentImage,
      paused: paused,
      counter: counter,
    );
    return _liveActivitiesPlugin.updateActivity(
      _latestActivityId!,
      data.toMap(),
    );
  }
}
