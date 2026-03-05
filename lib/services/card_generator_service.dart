library;

/// Unified card generator service
/// Exports platform-specific implementation
export 'card_generator_stub.dart'
    if (dart.library.html) 'card_generator_web.dart';
