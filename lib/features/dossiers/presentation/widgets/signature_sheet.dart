import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signature/signature.dart';

import '../../../../app/theme.dart';
import '../../data/document_upload_service.dart';

/// Bottom sheet "Signature electronique au doigt".
/// Pad plein ecran (au moins 60% de la hauteur), bouton effacer + bouton
/// envoyer. La signature est exportee en PNG et uploade comme document
/// type "signature" sur le dossier.
class SignatureSheet extends ConsumerStatefulWidget {
  final int dossierId;
  const SignatureSheet({super.key, required this.dossierId});

  static Future<bool?> show(BuildContext context, int dossierId) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: sdSurface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(sdRadiusLg)),
      ),
      builder: (_) => SignatureSheet(dossierId: dossierId),
    );
  }

  @override
  ConsumerState<SignatureSheet> createState() => _SignatureSheetState();
}

class _SignatureSheetState extends ConsumerState<SignatureSheet> {
  late final SignatureController _ctl;
  bool _uploading = false;
  bool _hasInk = false;

  @override
  void initState() {
    super.initState();
    _ctl = SignatureController(
      penStrokeWidth: 2.5,
      penColor: sdTextPrimary,
      exportBackgroundColor: Colors.white,
    )..addListener(() {
        final has = _ctl.isNotEmpty;
        if (has != _hasInk && mounted) {
          setState(() => _hasInk = has);
        }
      });
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_ctl.isEmpty) return;
    setState(() => _uploading = true);
    try {
      final bytes = await _ctl.toPngBytes();
      if (bytes == null) throw Exception('Export PNG impossible');
      await ref.read(documentUploadServiceProvider).uploadFromBytes(
            dossierId: widget.dossierId,
            bytes: bytes,
            nom: 'signature_${DateTime.now().millisecondsSinceEpoch}.png',
            typeDocument: 'signature',
            contentType: 'image/png',
          );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _uploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: sdLightGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.edit_outlined,
                      color: sdGreenBaobab, size: 24),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Signature',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Signez dans le cadre ci-dessous puis envoyez.',
                style: TextStyle(color: sdTextSecondary, fontSize: 13),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(sdRadiusMd),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFCDD6D9)),
                    borderRadius: BorderRadius.circular(sdRadiusMd),
                    color: Colors.white,
                  ),
                  height: h * 0.45,
                  child: Signature(
                    controller: _ctl,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _hasInk ? () => _ctl.clear() : null,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Effacer'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: (_hasInk && !_uploading) ? _send : null,
                      icon: _uploading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send),
                      label: const Text('Envoyer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
