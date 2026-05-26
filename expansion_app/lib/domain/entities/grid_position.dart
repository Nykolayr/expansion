import 'package:equatable/equatable.dart';

/// Клетка на поле боя (1-based, как в legacy JSON).
class GridPosition extends Equatable {
  const GridPosition({required this.x, required this.y});

  final int x;
  final int y;

  @override
  List<Object?> get props => [x, y];
}
