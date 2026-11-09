import '../../core/constants/alignment_constants.dart';

enum Alignment { redeemed, conflicted, fallen }

class HumanityState {
  final double humanity;
  final double corruption;

  const HumanityState({
    required this.humanity,
    required this.corruption,
  });

  factory HumanityState.initial() {
    return const HumanityState(
      humanity: AlignmentConstants.defaultScore,
      corruption: AlignmentConstants.defaultScore,
    );
  }

  HumanityState copyWith({
    double? humanity,
    double? corruption,
  }) {
    return HumanityState(
      humanity: (humanity ?? this.humanity).clamp(
        AlignmentConstants.minScore,
        AlignmentConstants.maxScore,
      ),
      corruption: (corruption ?? this.corruption).clamp(
        AlignmentConstants.minScore,
        AlignmentConstants.maxScore,
      ),
    );
  }

  Alignment get alignment {
    if (humanity >= AlignmentConstants.redeemedThreshold && humanity > corruption) {
      return Alignment.redeemed;
    } else if (corruption >= AlignmentConstants.fallenThreshold && corruption > humanity) {
      return Alignment.fallen;
    }
    return Alignment.conflicted;
  }
}
