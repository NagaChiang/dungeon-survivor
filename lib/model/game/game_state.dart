import 'package:freezed_annotation/freezed_annotation.dart';

import '../tile_map/tile_map.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

@freezed
class GameState with _$GameState {
  const factory GameState({
    required TileMap tileMap,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}
