import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme.dart';
import '../../data/document_upload_service.dart';

/// Bottom sheet "Scanner / joindre un document".
/// Etapes :
///   1. choix : camera OU galerie
///   2. preview + champ nom + bouton "Envoyer"
///   3. upload via DocumentUploadService -> snackbar succes
///
/// Note : pas d'OCR ici (necessiterait un package ML Kit + config native).
/// L'image est uploade en tant que justificatif et le backend la valide
/// manuellement comme un autre document.
class ScanDocumentSheet extends ConsumerStatefulWidget {
  final int dossierId;
  const ScanDocumentSheet({super.key, required this.dossierId});

  static Future<bool?> show(BuildContext context, int dossierId) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: sdSurface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(sdRadiusLg)),
      ),
      builder: (_) => ScanDocumentSheet(dossierId: dossierId),
    );
  }

  @override
  ConsumerState<ScanDocumentSheet> createState() => _ScanDocumentSheetState();
}

class _ScanDocumentSheetState extends ConsumerState<ScanDocumentSheet> {
  final _picker = ImagePicker();
  final _nameCtl = TextEditingController();
  XFile? _file;
  bool _uploading = false;

  @override
  void dispose() {
    _nameCtl.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final res = await _picker.pickImage(
        source: source,
        maxWidth: 2000,
        imageQuality: 85,
      );
      if (res == null) return;
      setState(() {
        _file = res;
        _nameCtl.text = res.name;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d\'ouvrir : $e')),
        );
      }
    }
  }

  Future<void> _upload() async {
    final f = _file;
    if (f == null) return;
    setState(() => _uploading = true);
    try {
      await ref.read(documentUploadServiceProvider).uploadFromPath(
            dossierId: widget.dossierId,
            path: f.path,
            nom: _nameCtl.text.trim().isEmpty ? f.name : _nameCtl.text.trim(),
            typeDocument: 'justificatif',
          );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _uploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l\'envoi : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.document_scanner_outlined,
                      color: sdGreenBaobab, size: 24),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Joindre un document',
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
                'Photographiez avec l\'appareil ou choisissez depuis votre galerie.',
                style: TextStyle(color: sdTextSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),
              if (_file == null)
                _SourcePicker(onPick: _pick)
              else
                _Preview(
                  file: _file!,
                  nameCtl: _nameCtl,
                  onChange: () => setState(() => _file = null),
                ),
              const SizedBox(height: 16),
              if (_file != null)
                FilledButton.icon(
                  onPressed: _uploading ? null : _upload,
                  icon: _uploading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.cloud_upload_outlined),
                  label: const Text('Envoyer'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourcePicker extends StatelessWidget {
  final void Function(ImageSource) onPick;
  const _SourcePicker({required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SourceTile(
            icon: Icons.camera_alt_outlined,
            label: 'Appareil photo',
            onTap: () => onPick(ImageSource.camera),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SourceTile(
            icon: Icons.photo_library_outlined,
            label: 'Galerie',
            onTap: () => onPick(ImageSource.gallery),
          ),
        ),
      ],
    );
  }
}

class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(sdRadiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: sdScaffoldBg,
          borderRadius: BorderRadius.circular(sdRadiusMd),
          border: Border.all(color: const Color(0xFFE2E8E6)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: sdGreenBaobab),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  final XFile file;
  final TextEditingController nameCtl;
  final VoidCallback onChange;
  const _Preview({
    required this.file,
    required this.nameCtl,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(sdRadiusMd),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.file(File(file.path), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: nameCtl,
          decoration: const InputDecoration(
            labelText: 'Nom du document',
            prefixIcon: Icon(Icons.label_outline),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onChange,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Changer'),
          ),
        ),
      ],
    );
  }
}
