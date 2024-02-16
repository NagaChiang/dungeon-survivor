import 'package:freezed_annotation/freezed_annotation.dart';

import '../unit/health.dart';

part 'tile.freezed.dart';
part 'tile.g.dart';

@freezed
class Tile with _$Tile {
  const Tile._();

  const factory Tile({
    required String id,
    required int x,
    required int y,
  }) = _Tile;

  @Implements<Health>()
  const factory Tile.player({
    required String id,
    required int x,
    required int y,
    required int health,
    required int maxHealth,
  }) = PlayerTile;

  @Implements<Health>()
  const factory Tile.enemy({
    required String id,
    required int x,
    required int y,
    required int health,
    required int maxHealth,
  }) = EnemyTile;

  factory Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);
}
