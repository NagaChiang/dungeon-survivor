import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../app/app_color.dart';
import '../unit/attackable.dart';
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
  @Implements<Attackable>()
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
    required int damage,
  }) = PlayerTile;

  @Implements<Health>()
  @Implements<Movable>()
  @Implements<Attackable>()
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
    required int damage,
  }) = EnemyTile;

  factory Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);

  Color get color => Color(colorValue);

  Tile updateHealth(int health) {
    if (this is PlayerTile) {
      return (this as PlayerTile).copyWith(health: health);
    } else if (this is EnemyTile) {
      return (this as EnemyTile).copyWith(health: health);
    } else {
      return this;
    }
  }

  Tile updateMoveCooldown(int cooldown) {
    if (this is PlayerTile) {
      return (this as PlayerTile).copyWith(moveCooldown: cooldown);
    } else if (this is EnemyTile) {
      return (this as EnemyTile).copyWith(moveCooldown: cooldown);
    } else {
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
      damage: 5,
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
      glyph: 'z',
      colorValue: Colors.lime.value,
      isBlocking: true,
      health: 10,
      maxHealth: 10,
      moveCooldown: 0,
      maxMoveCooldown: 2,
      damage: 5,
    );
  }
}
