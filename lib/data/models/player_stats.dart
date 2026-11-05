class PlayerStats {
  final double health;
  final double maxHealth;
  final double humanityMeter;

  const PlayerStats({
    required this.health,
    required this.maxHealth,
    required this.humanityMeter,
  });

  factory PlayerStats.initial() {
    return const PlayerStats(
      health: 100.0,
      maxHealth: 100.0,
      humanityMeter: 0.5,
    );
  }

  PlayerStats copyWith({
    double? health,
    double? maxHealth,
    double? humanityMeter,
  }) {
    return PlayerStats(
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      humanityMeter: (humanityMeter ?? this.humanityMeter).clamp(0.0, 1.0),
    );
  }
}
