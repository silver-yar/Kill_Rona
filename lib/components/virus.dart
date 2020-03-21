import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:corona_killer/corona_game.dart';

class Virus {
  final CoronaGame game;
  Rect virusRect;
  bool isDead = false;
  bool isOffScreen = false;
  List<Sprite> flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;

  Virus(this.game, double x, double y) {
    virusRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
  }

  void render(Canvas c) {
    if (isDead) {
      deadSprite.renderRect(c, virusRect.inflate(2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()].renderRect(c, virusRect.inflate(2));
    }
  }

  void update(double t) {
    if (isDead) {
      virusRect = virusRect.translate(0, game.tileSize * 12 * t);
      if (virusRect.top > game.screenSize.height) {
        isOffScreen = true;
      }
    } else {
      flyingSpriteIndex += 2 * t;
      if (flyingSpriteIndex >= 2) {
        flyingSpriteIndex -= 2;
      }
    }
  }

  void onTapDown() {
    isDead = true;
    game.spawnVirus();
  }
}