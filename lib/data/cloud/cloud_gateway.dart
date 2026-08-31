import 'dart:async';

/// Cloud gateway contract (spec §3): Firebase Auth + Firestore + Cloud
/// Functions + FCM. The client NEVER holds AI keys (⛔ §9.6) and NEVER
/// scrapes stores (⛔ §9.1) — everything goes through this contract.
///
/// Offline-first: the default binding is [LocalOnlyGateway]; when Firebase
/// config is present (google-services.json + flutterfire configure), the
/// production gateway implements the same contract against the real backend.
/// Without network everything keeps working locally (§1, criterion 12.2).
abstract class CloudGateway {
  /// True when a live backend connection is available.
  bool get isAvailable;

  // ── Sync ──────────────────────────────────────────────────────────────
  /// Push one entity to Firestore. Returns false on any failure (the sync
  /// queue retries with backoff). Implementations must be idempotent per id.
  Future<bool> pushEntity({
    required String collection,
    required String entityId,
    required Map<String, Object?> payload,
  });

  /// Pull server-side entities merged after [sinceMs] (Local-First Merge).
  Future<List<Map<String, Object?>>> pullEntities({
    required String collection,
    int sinceMs = 0,
  });

  // ── Cloud Functions (callable) ────────────────────────────────────────
  /// `chatWithAI(mode)` proxy — OpenAI key stays in Secret Manager (⛔ §7.2).
  /// Throws [CloudUnavailableException] when offline — callers fall back
  /// to local presets.
  Future<Map<String, Object?>> callFunction(String name, Map<String, Object?> args);

  // ── Auth (guest → account, §6.14) ─────────────────────────────────────
  Future<AuthResult> register({
    required String email,
    required String password,
    required String nickname,
  });
  Future<AuthResult> signIn({required String email, required String password});
  Future<void> signOut();
  Future<void> sendPasswordReset(String email);
  Future<void> deleteAccount();

  // ── Push (FCM) ────────────────────────────────────────────────────────
  Future<bool> registerPushToken(String token);
  Future<bool> isPushDeliverable();

  // ── Analytics / Crashlytics (anonymous UID, no PII ⛔ §9.9) ────────────
  void logEvent(String name, Map<String, Object?> params);
  void recordError(Object error, StackTrace stack);
}

class CloudUnavailableException implements Exception {
  const CloudUnavailableException(this.message);
  final String message;
  @override
  String toString() => 'CloudUnavailableException: $message';
}

class AuthResult {
  const AuthResult({required this.success, this.uid, this.nickname, this.error});
  final bool success;
  final String? uid;
  final String? nickname;
  final String? error;
}

/// Default binding: everything stays local (offline-first, §1).
/// `pushEntity` reports failure → the sync queue parks the task with
/// backoff; the moment a real gateway binds (Firebase configured + online),
/// flush resumes without data loss (criterion 12.2 — airplane-mode test).
class LocalOnlyGateway implements CloudGateway {
  @override
  bool get isAvailable => false;

  @override
  Future<bool> pushEntity({
    required String collection,
    required String entityId,
    required Map<String, Object?> payload,
  }) async =>
      false;

  @override
  Future<List<Map<String, Object?>>> pullEntities({
    required String collection,
    int sinceMs = 0,
  }) async =>
      const [];

  @override
  Future<Map<String, Object?>> callFunction(
      String name, Map<String, Object?> args) async {
    throw const CloudUnavailableException('offline: local-only gateway');
  }

  @override
  Future<AuthResult> register({
    required String email,
    required String password,
    required String nickname,
  }) async =>
      const AuthResult(success: false, error: 'offline_reg');

  @override
  Future<AuthResult> signIn({required String email, required String password}) async =>
      const AuthResult(success: false, error: 'offline_reg');

  @override
  Future<void> signOut() async {}

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<bool> registerPushToken(String token) async => false;

  @override
  Future<bool> isPushDeliverable() async => false;

  @override
  void logEvent(String name, Map<String, Object?> params) {}

  @override
  void recordError(Object error, StackTrace stack) {}
}

/// Production binding skeleton (Firebase). Wired via `flutterfire configure`;
/// kept as an explicit contract implementation so CI compiles it and the
/// client binary ships with a single, testable gateway interface.
///
/// NOTE: initialization is intentionally defensive — if
/// `Firebase.initializeApp()` throws (no google-services.json / no network),
/// the app binds [LocalOnlyGateway] and stays fully functional (§1).
class FirebaseGateway implements CloudGateway {
  FirebaseGateway({this.initialized = false});

  final bool initialized;
  final List<Map<String, Object?>> _eventLog = [];

  @override
  bool get isAvailable => initialized;

  @override
  Future<bool> pushEntity({
    required String collection,
    required String entityId,
    required Map<String, Object?> payload,
  }) async {
    if (!initialized) return false;
    try {
      // Production: FirebaseFirestore.instance
      //     .collection(collection).doc(entityId).set(payload, SetOptions(merge: true));
      return false; // placeholder until Firebase config is supplied
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<Map<String, Object?>>> pullEntities({
    required String collection,
    int sinceMs = 0,
  }) async =>
      const [];

  @override
  Future<Map<String, Object?>> callFunction(
      String name, Map<String, Object?> args) async {
    throw const CloudUnavailableException('Firebase not configured in this build');
  }

  @override
  Future<AuthResult> register({
    required String email,
    required String password,
    required String nickname,
  }) async =>
      const AuthResult(success: false, error: 'Firebase not configured');

  @override
  Future<AuthResult> signIn({required String email, required String password}) async =>
      const AuthResult(success: false, error: 'Firebase not configured');

  @override
  Future<void> signOut() async {}

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<bool> registerPushToken(String token) async => false;

  @override
  Future<bool> isPushDeliverable() async => false;

  @override
  void logEvent(String name, Map<String, Object?> params) {
    _eventLog.add({'name': name, 'params': params});
  }

  @override
  void recordError(Object error, StackTrace stack) {}
}
