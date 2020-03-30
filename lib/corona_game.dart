import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:corona_killer/components/virus.dart';
import 'package:corona_killer/components/covid.dart';
import 'package:corona_killer/components/background.dart';
import 'package:corona_killer/view.dart';
import 'package:corona_killer/views/home-view.dart';
import 'package:corona_killer/components/start-button.dart';
import 'package:corona_killer/components/donate-button.dart';
import 'package:corona_killer/views/lost-view.dart';
import 'package:corona_killer/controllers/spawner.dart';
import 'package:corona_killer/components/score-display.dart';
import 'package:corona_killer/components/highscore-display.dart';
import 'package:corona_killer/components/sound-button.dart';

class CoronaGame extends Game {
  Size screenSize;
  double tileSize;
  List<Virus> viruses;
  Random rnd;
  View activeView = View.home;
  Background background;
  HomeView homeView;
  LostView lostView;
  StartButton startButton;
  DonateButton donateButton;
  VirusSpawner spawner;
  int score;
  ScoreDisplay scoreDisplay;
  final SharedPreferences storage;
  HighscoreDisplay highscoreDisplay;
  SoundButton soundButton;

  CoronaGame(this.storage) {
    initialize();
  }

  void initialize() async {
    score = 0;
    viruses = List<Virus>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());

    background = Background(this);
    scoreDisplay = ScoreDisplay(this);
    highscoreDisplay = HighscoreDisplay(this);
    soundButton = SoundButton(this);
    spawner = VirusSpawner(this);
    homeView = HomeView(this);
    donateButton = DonateButton(this);
    startButton = StartButton(this);
    lostView = LostView(this);
  }

  void spawnVirus() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize);
    double y = rnd.nextDouble() * (screenSize.height - tileSize);
    viruses.add(Covid(this, x, y));
  }

  void render(Canvas canvas) {
    background.render(canvas);

    highscoreDisplay.render(canvas);
    if (activeView == View.playing) scoreDisplay.render(canvas);

    viruses.forEach((Virus virus) => virus.render(canvas));
    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      donateButton.render(canvas);
    }
    if (activeView == View.lost) lostView.render(canvas);
    
    soundButton.render(canvas);
  }

  void update(double t) {
    spawner.update(t);
    viruses.forEach((Virus virus) => virus.update(t));
    viruses.removeWhere((Virus virus) => virus.isOffScreen);
    if (activeView == View.playing) scoreDisplay.update(t);
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

    // Donate Button
    if (!isHandled && donateButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        donateButton.onTapDown();
        isHandled = true;
      }
    }

    // sound button
    if (!isHandled && soundButton.rect.contains(d.globalPosition)) {
      soundButton.onTapDown();
      isHandled = true;
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
        if (soundButton.isEnabled) {
          Flame.audio.play('sfx/shit_real.mp3');
        }
        activeView = View.lost;
      }
    }
  }
}