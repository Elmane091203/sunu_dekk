import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../data/team_repository.dart';

class CreateAgentSheet extends ConsumerStatefulWidget {
  const CreateAgentSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: sdSurface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(sdRadiusLg)),
      ),
      builder: (_) => const CreateAgentSheet(),
    );
  }

  @override
  ConsumerState<CreateAgentSheet> createState() => _CreateAgentSheetState();
}

class _CreateAgentSheetState extends ConsumerState<CreateAgentSheet> {
  final _form = GlobalKey<FormState>();
  final _nom = TextEditingController();
  final _prenom = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  String _role = 'agent';
  bool _saving = false;

  @override
  void dispose() {
    _nom.dispose();
    _prenom.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(teamRepositoryProvider).create(
            nom: _nom.text.trim(),
            prenom: _prenom.text.trim(),
            email: _email.text.trim(),
            telephone: _phone.text.trim(),
            password: _password.text,
            role: _role,
          );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Création impossible : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Form(
            key: _form,
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
                    const Icon(Icons.person_add_outlined,
                        color: sdGreenBaobab),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Nouveau collaborateur',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _prenom,
                        decoration: const InputDecoration(labelText: 'Prénom'),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Requis' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _nom,
                        decoration: const InputDecoration(labelText: 'Nom'),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Requis' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Email invalide'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phone,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                    prefixIcon: Icon(Icons.phone_outlined),
                    hintText: '+221...',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe initial',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (v) => (v == null || v.length < 6)
                      ? '6 caractères min'
                      : null,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Rôle',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Agent'),
                      selected: _role == 'agent',
                      onSelected: (_) => setState(() => _role = 'agent'),
                    ),
                    ChoiceChip(
                      label: const Text('Administrateur'),
                      selected: _role == 'admin',
                      onSelected: (_) => setState(() => _role = 'admin'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check),
                  label: const Text('Créer le compte'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
