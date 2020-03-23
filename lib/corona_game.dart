import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:corona_killer/components/virus.dart';
import 'package:corona_killer/components/covid.dart';
import 'package:corona_killer/view.dart';
import 'package:corona_killer/views/home-view.dart';
import 'package:corona_killer/components/start-button.dart';
import 'package:corona_killer/views/lost-view.dart';

class CoronaGame extends Game {
  Size screenSize;
  double tileSize;
  List<Virus> viruses;
  Random rnd;

  View activeView = View.home;
  HomeView homeView;
  LostView lostView;

  StartButton startButton;

  CoronaGame() {
    initialize();
  }

  void initialize() async {
    viruses = List<Virus>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());

    homeView = HomeView(this);
    startButton = StartButton(this);
    lostView = LostView(this);
    spawnVirus();
  }

  void spawnVirus() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize);
    double y = rnd.nextDouble() * (screenSize.height - tileSize);
    viruses.add(Covid(this, x, y));
  }

  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff576574);
    canvas.drawRect(bgRect, bgPaint);

    viruses.forEach((Virus virus) => virus.render(canvas));
    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
    }
    if (activeView == View.lost) lostView.render(canvas);
    //print('rendered');
  }

  void update(double t) {
    viruses.forEach((Virus virus) => virus.update(t));
    viruses.removeWhere((Virus virus) => virus.isOffScreen);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails d) {
    bool isHandled = false;

    // Start Button
    if (!isHandled && startButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }

    // Viruses
    if (!isHandled) {
      bool didHitAVirus = false;
      viruses.forEach((Virus virus) {
      if (virus.virusRect.contains(d.globalPosition)) {
        virus.onTapDown();
        isHandled = true;
        didHitAVirus = true;
      }
      });
      if (activeView == View.playing && !didHitAVirus) {
        activeView = View.lost;
      }
    }
  }
}