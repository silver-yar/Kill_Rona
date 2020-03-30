import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:corona_killer/corona_game.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);
  Flame.images.loadAll(<String>[
    'background_globe.png',
    'rona.png',
    'dead_rona.png',
    'callout.png',
    'icon-sound-disabled.png',
    'icon-sound-enabled.png',
  ]);
  Flame.audio.disableLog();
  Flame.audio.loadAll(<String>[
    'bgm/home.mp3',
    'bgm/playing.mp3',
    'sfx/corona_one.mp3',
    'sfx/corona_two.mp3',
    'sfx/shit_real.mp3',
    'sfx/woo.mp3',
  ]);

  SharedPreferences storage = await SharedPreferences.getInstance();

  CoronaGame game = CoronaGame(storage);
  runApp(game.widget);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  flameUtil.addGestureRecognizer(tapper);
}





