import 'package:expansion/l10n/app_localizations.dart';

String resolveAuthMessage(AppLocalizations loc, String? keyOrMessage) {
  if (keyOrMessage == null || keyOrMessage.isEmpty) {
    return loc.authErrorGeneric;
  }

  return switch (keyOrMessage) {
    'authErrorEmailExists' => loc.authErrorEmailExists,
    'authErrorNickTaken' => loc.authErrorNickTaken,
    'authErrorEmailSend' => loc.authErrorEmailSend,
    'authErrorInvalidCredentials' => loc.authErrorInvalidCredentials,
    'authErrorInvalidCode' => loc.authErrorInvalidCode,
    'profileWrongCurrentPassword' => loc.profileWrongCurrentPassword,
    _ => keyOrMessage,
  };
}

String nickAvailabilityHint(AppLocalizations loc, String? reason) {
  return switch (reason) {
    'NICK_LENGTH' => loc.authNickTooShort,
    'NICK_FORMAT' => loc.authNickInvalid,
    'NICK_RESERVED' => loc.authNickReserved,
    _ => loc.authNickTaken,
  };
}
