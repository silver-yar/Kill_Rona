import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:corona_killer/components/virus.dart';
import 'package:corona_killer/components/covid.dart';

class CoronaGame extends Game {
  Size screenSize;
  double tileSize;
  List<Virus> viruses;
  Random rnd;

  CoronaGame() {
    initialize();
  }

  void initialize() async {
    viruses = List<Virus>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());

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
    viruses.forEach((Virus virus) {
      if (virus.virusRect.contains(d.globalPosition)) {
        virus.onTapDown();
      }
    });
  }
}