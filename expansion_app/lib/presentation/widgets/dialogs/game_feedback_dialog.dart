import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/core/ui/app_feedback_kind.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/domain/repositories/auth_repository.dart';
import 'package:expansion/domain/repositories/feedback_repository.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/buttons/game_compact_skew_button.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';

Future<void> showGameFeedbackDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (ctx) => const _GameFeedbackDialog(),
  );
}

class _GameFeedbackDialog extends StatefulWidget {
  const _GameFeedbackDialog();

  @override
  State<_GameFeedbackDialog> createState() => _GameFeedbackDialogState();
}

class _GameFeedbackDialogState extends State<_GameFeedbackDialog> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _emailController = TextEditingController();

  bool _loadingAuth = true;
  bool _isLoggedIn = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final loggedIn = await sl<AuthRepository>().isLoggedIn();
    if (!mounted) return;
    setState(() {
      _isLoggedIn = loggedIn;
      _loadingAuth = false;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final loc = AppLocalizations.of(context)!;

    final result = await sl<FeedbackRepository>().submit(
      message: _messageController.text,
      guestEmail: _isLoggedIn ? null : _emailController.text,
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    result.fold(
      (_) {
        sl<AppFeedbackService>().show(
          loc.feedbackFailed,
          kind: AppFeedbackKind.error,
        );
      },
      (_) {
        Navigator.of(context).pop();
        sl<AppFeedbackService>().show(
          loc.feedbackSuccess,
          kind: AppFeedbackKind.success,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 10,
        color: ExpansionColors.background.withValues(alpha: 0.96),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: ExpansionColors.accent, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: _loadingAuth
              ? const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        loc.feedbackTitle,
                        textAlign: TextAlign.center,
                        style: ExpansionTextStyles.bodyAccent(context, 20),
                      ),
                      const Gap(8),
                      Text(
                        _isLoggedIn
                            ? loc.feedbackHintLoggedIn
                            : loc.feedbackHintGuest,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Gap(16),
                      if (!_isLoggedIn) ...[
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: loc.feedbackEmailLabel,
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty) {
                              return loc.feedbackEmailRequired;
                            }
                            if (!email.contains('@') || !email.contains('.')) {
                              return loc.feedbackEmailInvalid;
                            }
                            return null;
                          },
                        ),
                        const Gap(12),
                      ],
                      TextFormField(
                        controller: _messageController,
                        minLines: 4,
                        maxLines: 8,
                        maxLength: 2000,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: loc.feedbackMessageLabel,
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.length < 10) {
                            return loc.feedbackMessageTooShort;
                          }
                          return null;
                        },
                      ),
                      const Gap(16),
                      GameLongButton(
                        label: loc.feedbackSend,
                        loading: _submitting,
                        onPressed: _submitting ? null : _submit,
                      ),
                      const Gap(10),
                      Center(
                        child: GameCompactSkewButton(
                          label: loc.beginResetCancel,
                          fullWidth: true,
                          fontSize: 15,
                          onPressed: _submitting
                              ? null
                              : () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
