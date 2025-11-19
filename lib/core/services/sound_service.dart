import 'dart:developer';

abstract class SoundService {
  void playSuccess();
  void playWarning();
}

class DebugSoundService implements SoundService {
  @override
  void playSuccess() {
    // TODO: integrate audio playback package when available.
    log('playSuccess() called');
  }

  @override
  void playWarning() {
    log('playWarning() called');
  }
}
