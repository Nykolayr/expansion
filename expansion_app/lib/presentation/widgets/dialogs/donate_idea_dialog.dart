import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/domain/repositories/auth_repository.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/services/expansion_platform_sync_service.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';

/// Диалог идеи перед оплатой tier3. Возвращает `ideaId` или `null`.
Future<String?> showDonateIdeaDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (ctx) => const _DonateIdeaDialog(),
  );
}

class _DonateIdeaDialog extends StatefulWidget {
  const _DonateIdeaDialog();

  @override
  State<_DonateIdeaDialog> createState() => _DonateIdeaDialogState();
}

class _DonateIdeaDialogState extends State<_DonateIdeaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _ideaController = TextEditingController();
  final _emailController = TextEditingController();

  var _loadingAuth = true;
  var _isLoggedIn = false;
  var _submitting = false;

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
    _ideaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final loc = AppLocalizations.of(context)!;

    try {
      final ideaId = await sl<ExpansionPlatformSyncService>().submitDonationIdea(
        ideaText: _ideaController.text,
        guestEmail: _isLoggedIn ? null : _emailController.text,
      );
      if (!mounted) return;
      if (ideaId == null) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.donateIdeaFailed)),
        );
        return;
      }
      Navigator.of(context).pop(ideaId);
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.donateIdeaFailed)),
      );
    }
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
                        loc.donateIdeaTitle,
                        textAlign: TextAlign.center,
                        style: ExpansionTextStyles.bodyAccent(context, 20),
                      ),
                      const Gap(8),
                      Text(
                        loc.donateIdeaBody,
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
                        controller: _ideaController,
                        minLines: 4,
                        maxLines: 8,
                        maxLength: 2000,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: loc.donateIdeaLabel,
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
                        label: loc.donateIdeaContinue,
                        loading: _submitting,
                        onPressed: _submitting ? null : _submit,
                      ),
                      const Gap(10),
                      GameLongButton(
                        label: loc.beginResetCancel,
                        fontSize: 16,
                        onPressed: _submitting
                            ? null
                            : () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
