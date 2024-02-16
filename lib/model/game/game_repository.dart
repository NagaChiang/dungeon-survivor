import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../app/app_color.dart';
import '../tile_map/tile.dart';
import '../tile_map/tile_map.dart';
import 'game_state.dart';

class GameRepository {
  final _gameStateSubject = BehaviorSubject<GameState>();
  late final gameStateStream = _gameStateSubject.stream;

  late final tileMapStream = gameStateStream.map(
    (gameState) => gameState.tileMap,
  );

  late final playerTileStream = tileMapStream
      .map(
        (tileMap) => tileMap.findPlayerTile(),
      )
      .whereNotNull();

  late final playerTileIdStream = playerTileStream.map(
    (playerTile) => playerTile.id,
  );

  final _uuid = const Uuid();

  void init() {
    // TODO: Load game state from storage first

    createNewGame();
  }

  void createNewGame() {
    final player = Tile.player(
      id: _uuid.v4(),
      glyph: '@',
      colorValue: AppColor.white87.value,
      x: 50,
      y: 50,
      health: 100,
      maxHealth: 100,
    );

    final rats = List.generate(
      10,
      (index) => Tile.enemy(
        id: _uuid.v4(),
        glyph: 'r',
        colorValue: Colors.orangeAccent.value,
        x: 50 + index + 1,
        y: 50 + index + 1,
        health: 10,
        maxHealth: 10,
      ),
    );

    final tileMap = TileMap(
      widthTileCount: 100,
      heightTileCount: 100,
      tiles: [player, ...rats],
    );

    final gameState = GameState(tileMap: tileMap);

    _gameStateSubject.add(gameState);
  }

  Stream<Tile> getTileStream(String id) {
    return tileMapStream
        .map(
          (tileMap) => tileMap.findTile(id),
        )
        .whereNotNull();
  }
}
