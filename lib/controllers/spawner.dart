import 'package:corona_killer/corona_game.dart';
import 'package:corona_killer/components/virus.dart';

class FlySpawner {
  final CoronaGame game;
  final int maxSpawnInterval = 3000;
  final int minSpawnInterval = 250;
  final int intervalChange = 3;
  final int maxFliesOnScreen = 7;

  int currentInterval;
  int nextSpawn;

  FlySpawner(this.game) {
    start();
    game.spawnVirus();
  }

  void start() {
    killAll();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void killAll() {
    game.viruses.forEach((Virus virus) => virus.isDead = true);
  }

  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;

    int livingViruses = 0;
    game.viruses.forEach((Virus virus) {
      if (!virus.isDead) livingViruses += 1;
    });

    if (nowTimestamp >= nextSpawn && livingViruses < maxFliesOnScreen) {
      game.spawnVirus();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * .02).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval;
    }
  }
}