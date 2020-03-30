import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:corona_killer/corona_game.dart';
import 'package:url_launcher/url_launcher.dart';

class DonateButton {
  final CoronaGame game;
  Rect rect;
  Sprite sprite;

  DonateButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 2,
      (game.screenSize.height * .95) - (game.tileSize * 1.5),
      game.tileSize * 5,
      game.tileSize * 2,
    );
    sprite = Sprite('donate.png');
  }

  launchUrl() async {
    const url = 'https://support.savethechildren.org/site/Donation2?df_id=4067&mfc_pref=T&4067.donation=form1';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void onTapDown() {
    launchUrl();
  }
}