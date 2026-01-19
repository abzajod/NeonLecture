import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String id;
  final String? name;
  final String? email;
  final bool isGuest;

  UserProfile({
    required this.id,
    this.name,
    this.email,
    this.isGuest = false,
  });
}

class AuthNotifier extends StateNotifier<UserProfile?> {
  AuthNotifier() : super(null);

  Future<void> signInAsGuest() async {
    // Mimic sign-in delay
    await Future.delayed(const Duration(seconds: 1));
    state = UserProfile(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Guest User',
      isGuest: true,
    );
  }

  void signOut() {
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserProfile?>((ref) {
  return AuthNotifier();
});
