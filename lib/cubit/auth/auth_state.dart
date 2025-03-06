import 'package:phoenix/helper/enum_helper.dart';

class AuthState {
  ProcessState? authState;

  AuthState({
    this.authState = ProcessState.none,
  });

  AuthState copyWith({ProcessState? authState}) {
    return AuthState(authState: authState ?? this.authState);
  }
}
