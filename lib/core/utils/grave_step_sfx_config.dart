class GraveStepSfxConfig {
  final String effectName;
  final double durationSeconds;
  final double subBassFrequencyHz;
  final double filterSweepStartHz;
  final double filterSweepEndHz;
  final double alienShimmerPitchHz;

  const GraveStepSfxConfig({
    required this.effectName,
    required this.durationSeconds,
    required this.subBassFrequencyHz,
    required this.filterSweepStartHz,
    required this.filterSweepEndHz,
    required this.alienShimmerPitchHz,
  });

  factory GraveStepSfxConfig.defaultGraveStep() {
    return const GraveStepSfxConfig(
      effectName: 'sfx_grave_step_dissolve.wav',
      durationSeconds: 0.6,
      subBassFrequencyHz: 42.0,
      filterSweepStartHz: 850.0,
      filterSweepEndHz: 120.0,
      alienShimmerPitchHz: 3400.0,
    );
  }
}
