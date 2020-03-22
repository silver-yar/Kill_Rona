import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:corona_killer/components/virus.dart';
import 'package:corona_killer/corona_game.dart';

class Covid extends Virus {
  Covid(CoronaGame game, double x, double y) : super(game) {
    virusRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('rona.png'));
    flyingSprite.add(Sprite('glow_rona.png'));
    deadSprite = Sprite('dead_rona.png');
  }
}