import 'dart:math';

class AmbientTrackConfig {
  final String title;
  final double durationSeconds;
  final double bpm;
  final String rootKey;
  final List<double> droneFrequenciesHz;
  final List<double> pianoScaleFrequenciesHz;
  final double windFilterCutoffHz;

  const AmbientTrackConfig({
    required this.title,
    required this.durationSeconds,
    required this.bpm,
    required this.rootKey,
    required this.droneFrequenciesHz,
    required this.pianoScaleFrequenciesHz,
    required this.windFilterCutoffHz,
  });

  factory AmbientTrackConfig.graveyardNightLoop() {
    return const AmbientTrackConfig(
      title: 'Echoes of the Unconsecrated Ground',
      durationSeconds: 120.0,
      bpm: 50.0,
      rootKey: 'C Minor',
      droneFrequenciesHz: [65.41, 97.99, 130.81],
      pianoScaleFrequenciesHz: [130.81, 155.56, 196.00, 233.08, 261.63, 311.13, 392.00],
      windFilterCutoffHz: 400.0,
    );
  }
}

class AmbientSoundGenerator {
  final AmbientTrackConfig config;
  final Random _random = Random();

  AmbientSoundGenerator([AmbientTrackConfig? trackConfig])
      : config = trackConfig ?? AmbientTrackConfig.graveyardNightLoop();

  double generateSparsePianoNote(double timeSeconds) {
    if (timeSeconds % 6.0 < 0.1) {
      final noteIndex = _random.nextInt(config.pianoScaleFrequenciesHz.length);
      return config.pianoScaleFrequenciesHz[noteIndex];
    }
    return 0.0;
  }

  double calculateLowDroneAmplitude(double timeSeconds) {
    return 0.4 + 0.1 * sin(timeSeconds * 0.05);
  }

  double calculateWindFilterSweeps(double timeSeconds) {
    return config.windFilterCutoffHz + 150.0 * sin(timeSeconds * 0.15);
  }
}
