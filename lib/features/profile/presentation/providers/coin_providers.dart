import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/services/coin_service.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../../authentication/presentation/states/auth_state.dart';
import '../../data/repositories/coin_ledger_repository_impl.dart';
import '../../domain/entities/coin_transaction.dart';
import '../states/profile_state.dart';
import 'profile_providers.dart';

/// Provider for the coin-ledger persistence boundary.
///
/// Returns a Firestore-backed implementation when
/// [FirebaseConfig.isPlatformConfigured] is `true`; otherwise an
/// in-memory implementation that survives only as long as the
/// process (used for unit tests, dev sessions without Firebase
/// configured, and the in-app guest path).
final coinLedgerRepositoryProvider = Provider<CoinLedgerRepository>((ref) {
  final FirebaseFirestore? firestore = FirebaseConfig.firestore;
  if (FirebaseConfig.isPlatformConfigured && firestore != null) {
    return FirestoreCoinLedgerRepositoryImpl(firestore);
  }
  final InMemoryCoinLedgerRepository repo = InMemoryCoinLedgerRepository();
  ref.onDispose(repo.close);
  return repo;
});

/// Provider for the [CoinService] singleton. Wires the
/// ledger-repository provider above and the auth / profile
/// providers used for guest detection and local mirroring.
final coinServiceProvider = Provider<CoinService>((ref) {
  return CoinService(ref);
});

/// Canonical coin balance, sourced from the in-memory profile. Every
/// coin indicator in the app should watch this provider rather than
/// reaching into the profile directly.
final coinBalanceProvider = Provider<int>((ref) {
  final ProfileState state = ref.watch(profileControllerProvider);
  return state.profile?.progression.coins ?? 0;
});

/// Live stream of the authenticated user's recent transactions.
/// Gated on a real auth uid — emits an empty list for guests.
final coinHistoryProvider = StreamProvider<List<CoinTransactionEntity>>((ref) {
  final AuthState auth = ref.watch(authStateProvider);
  final String uid = auth.user?.id ?? '';
  if (uid.isEmpty || auth.user?.email.isEmpty == true) {
    return Stream<List<CoinTransactionEntity>>.value(const <CoinTransactionEntity>[]);
  }
  final CoinLedgerRepository repo = ref.watch(coinLedgerRepositoryProvider);
  return repo.watch(uid);
});
