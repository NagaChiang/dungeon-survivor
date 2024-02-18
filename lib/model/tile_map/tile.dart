import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../app/app_color.dart';
import '../unit/health.dart';
import '../unit/movable.dart';

part 'tile.freezed.dart';
part 'tile.g.dart';

@freezed
class Tile with _$Tile {
  const Tile._();

  const factory Tile({
    required String id,
    required int x,
    required int y,
    required String glyph,
    required int colorValue,
    required bool isBlocking,
  }) = _Tile;

  @Implements<Health>()
  @Implements<Movable>()
  const factory Tile.player({
    required String id,
    required int x,
    required int y,
    required String glyph,
    required int colorValue,
    required bool isBlocking,
    required int health,
    required int maxHealth,
    required int moveCooldown,
    required int maxMoveCooldown,
  }) = PlayerTile;

  @Implements<Health>()
  @Implements<Movable>()
  const factory Tile.enemy({
    required String id,
    required int x,
    required int y,
    required String glyph,
    required int colorValue,
    required bool isBlocking,
    required int health,
    required int maxHealth,
    required int moveCooldown,
    required int maxMoveCooldown,
  }) = EnemyTile;

  factory Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);

  Color get color => Color(colorValue);

  Tile copyWithMoveCooldown(int cooldown) {
    switch (runtimeType) {
      case PlayerTile:
        return (this as PlayerTile).copyWith(moveCooldown: cooldown);
      case EnemyTile:
        return (this as EnemyTile).copyWith(moveCooldown: cooldown);
      default:
        return this;
    }
  }

  static Tile createPlayer(
    String id,
    int x,
    int y,
  ) {
    return Tile.player(
      id: id,
      x: x,
      y: y,
      glyph: '@',
      colorValue: AppColor.white87.value,
      isBlocking: true,
      health: 100,
      maxHealth: 100,
      moveCooldown: 0,
      maxMoveCooldown: 1,
    );
  }

  static Tile createEnemy(
    String id,
    int x,
    int y,
  ) {
    return Tile.enemy(
      id: id,
      x: x,
      y: y,
      glyph: 'r',
      colorValue: Colors.orangeAccent.value,
      isBlocking: true,
      health: 10,
      maxHealth: 10,
      moveCooldown: 0,
      maxMoveCooldown: 2,
    );
  }
}
