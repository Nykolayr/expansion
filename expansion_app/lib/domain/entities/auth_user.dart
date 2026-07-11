import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.email,
    required this.nick,
    required this.realName,
    required this.emailVerified,
  });

  final String id;
  final String email;
  final String nick;
  final String realName;
  final bool emailVerified;

  @override
  List<Object?> get props => [id, email, nick, realName, emailVerified];
}
