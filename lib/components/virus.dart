import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:corona_killer/corona_game.dart';
import 'package:corona_killer/view.dart';
import 'package:corona_killer/components/callout.dart';

class Virus {
  final CoronaGame game;
  Rect virusRect;
  bool isDead = false;
  bool isOffScreen = false;
  List<Sprite> flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;
  Offset targetLocation;
  Callout callout;

  int soundNum = 1;

  double get speed => game.tileSize * 3;

  Virus(this.game) {
    setTargetLocation();
    callout = Callout(this);
  }

  void setTargetLocation() {
    double x = game.rnd.nextDouble() * (game.screenSize.width - (game.tileSize * 2.025));
    double y = game.rnd.nextDouble() * (game.screenSize.height - (game.tileSize * 2.025));
    targetLocation = Offset(x, y);
  }

  void render(Canvas c) {
    if (isDead) {
      deadSprite.renderRect(c, virusRect.inflate(2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()].renderRect(c, virusRect.inflate(2));
      if (game.activeView == View.playing) {
        callout.render(c);
      }
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

      double stepDistance = speed * t;
      Offset toTarget = targetLocation - Offset(virusRect.left, virusRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        virusRect = virusRect.shift(stepToTarget);
      } else {
        virusRect = virusRect.shift(toTarget);
        setTargetLocation();
      }
      callout.update(t);
    }
  }

  void onTapDown() {
    if (!isDead) {
      soundNum = game.rnd.nextInt(3) + 1;
      if (game.soundButton.isEnabled) {
        switch (soundNum) {
          case 1: Flame.audio.play('sfx/corona_one.mp3');
          break;

          case 2: Flame.audio.play('sfx/corona_two.mp3');
          break;

          case 3: Flame.audio.play('sfx/woo.mp3');
          break;

          default: Flame.audio.play('sfx/corona_one.mp3');
          break;
        }
      }
      
      isDead = true;
      if (game.activeView == View.playing) {
        game.score += 1;
        
        if (game.score > (game.storage.getInt('highscore') ?? 0)) {
          game.storage.setInt('highscore', game.score);
          game.highscoreDisplay.updateHighscore();
        }
      }
    }
  }

}