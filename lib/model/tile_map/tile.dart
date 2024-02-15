import 'package:freezed_annotation/freezed_annotation.dart';

import '../unit/health.dart';

part 'tile.freezed.dart';
part 'tile.g.dart';

@freezed
class Tile with _$Tile {
  const Tile._();

  const factory Tile({
    required int posX,
    required int posY,
  }) = _Tile;

  @Implements<Health>()
  const factory Tile.player({
    required int posX,
    required int posY,
    required int health,
    required int maxHealth,
  }) = PlayerTile;

  @Implements<Health>()
  const factory Tile.enemy({
    required int posX,
    required int posY,
    required int health,
    required int maxHealth,
  }) = EnemyTile;

  factory Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);
}
