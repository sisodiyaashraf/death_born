class BossFightMusicConfig {
  final String title;
  final double durationSeconds;
  final double bpm;
  final String keySignature;
  final List<String> instrumentation;
  final Map<String, dynamic> arrangementMap;

  const BossFightMusicConfig({
    required this.title,
    required this.durationSeconds,
    required this.bpm,
    required this.keySignature,
    required this.instrumentation,
    required this.arrangementMap,
  });

  factory BossFightMusicConfig.enforcerBossTheme() {
    return const BossFightMusicConfig(
      title: 'The Enforcer: Heavy Steel & Alien Core',
      durationSeconds: 90.0,
      bpm: 140.0,
      keySignature: 'D Minor',
      instrumentation: [
        'Industrial Kick & Distortion Snare',
        'Overdriven Sawtooth Bass',
        'Staccato Tense Strings (D4/F4/A4)',
        'Resonant Alenoid Pulse Synth (734 Hz LFO)',
      ],
      arrangementMap: {
        'introBar': '0:00 - 0:15 | Tense string ostinato & alien pulse swell',
        'dropBar': '0:15 - 0:45 | Heavy 140 BPM industrial drum drive & distorted bass',
        'climaxBar': '0:45 - 1:15 | Full orchestral stabs & aggressive synth sweeps',
        'outroBar': '1:15 - 1:30 | Seamless loop transition back to bar 1',
      },
    );
  }
}
