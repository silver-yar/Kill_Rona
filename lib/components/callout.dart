import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:corona_killer/components/virus.dart';
import 'package:flutter/material.dart';
import 'package:corona_killer/view.dart';

class Callout {
  final Virus virus;
  Rect rect;
  Sprite sprite;
  double value;

  TextPainter tp;
  TextStyle textStyle;
  Offset textOffset;

  Callout(this.virus) {
    sprite = Sprite('callout.png');
    value = 1;
    tp = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textStyle = TextStyle(
      color: Color(0xff000000),
      fontSize: 15,
    );
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
    tp.paint(c, textOffset);
  }

  void update(double t) {
    if (virus.game.activeView == View.playing) {
      value = value - .5 * t;
      if (value <= 0) {
        if (virus.game.soundButton.isEnabled) {
          Flame.audio.play('sfx/shit_real.mp3');
        }
        virus.game.activeView = View.lost;
      }
    }

    rect = Rect.fromLTWH(
      virus.virusRect.left - (virus.game.tileSize * .25),
      virus.virusRect.top - (virus.game.tileSize * .5),
      virus.game.tileSize * .75,
      virus.game.tileSize * .75,
    );

    tp.text = TextSpan(
      text: (value * 10).toInt().toString(),
      style: textStyle,
    );
    tp.layout();
    textOffset = Offset(
      rect.center.dx - (tp.width / 2),
      rect.top + (rect.height * .4) - (tp.height / 2),
    );
  }
}