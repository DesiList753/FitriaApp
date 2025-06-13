import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../login_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Campos de información de usuario editables
  String _name = '';
  String _email = '';
  String _genero = '';
  double _height = 0;
  double _peso = 0;

  DateTime? _birthDate;

  bool _isEditing = false;
  bool _isLoading = true;
  DateTime? _tempBirthDate;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      final data = doc.data();
      setState(() {
        _name = data?['name'] ?? '';
        _email = data?['email'] ?? user.email ?? '';
        _genero = data?['genero'] ?? '';
        _height = (data?['height'] ?? 0).toDouble();
        _peso = (data?['peso'] ?? 0).toDouble();
        _birthDate =
            data?['birthDate'] != null
                ? DateTime.tryParse(data?['birthDate'])
                : null;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _name,
        'email': _email,
        'genero': _genero,
        'height': _height,
        'peso': _peso,
        'birthDate': _birthDate?.toIso8601String(),
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Usar la variable temporal solo en edición
    final birthDateToShow =
        _isEditing ? _tempBirthDate ?? _birthDate : _birthDate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Solo si se guarda, actualiza la fecha real
                  setState(() {
                    _birthDate = _tempBirthDate ?? _birthDate;
                  });
                  await _saveUserData();
                  setState(() {
                    _isEditing = false;
                    _tempBirthDate = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Perfil actualizado')),
                  );
                } else {
                  // Si hay error de validación, no salir del modo edición
                  return;
                }
              } else {
                setState(() {
                  _isEditing = true;
                  _tempBirthDate = _birthDate;
                });
              }
            },
          ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // Al cancelar, descarta cambios temporales
                setState(() {
                  _isEditing = false;
                  _tempBirthDate = null;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Text(
                      'IM',
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ),
                  ),
                  if (_isEditing)
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          // Implementar cambio de foto
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              buildTextField(
                label: 'Nombre',
                value: _name,
                enabled: _isEditing,
                onSaved: (value) => _name = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              buildTextField(
                label: 'Correo electrónico',
                value: _email,
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {},
                validator: (value) => null,
              ),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      label: 'Edad',
                      value: _getEdadFromBirthDate(birthDateToShow),
                      enabled: false,
                      onSaved: (value) {},
                      validator: (value) => null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                        _isEditing
                            ? GestureDetector(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      birthDateToShow ?? DateTime(2000),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    _tempBirthDate = picked;
                                  });
                                }
                              },
                              child: AbsorbPointer(
                                child: buildTextField(
                                  label: 'Fecha de nacimiento',
                                  value:
                                      birthDateToShow != null
                                          ? '${birthDateToShow.day}/${birthDateToShow.month}/${birthDateToShow.year}'
                                          : '',
                                  enabled: false,
                                  onSaved: (value) {},
                                  validator: (value) => null,
                                ),
                              ),
                            )
                            : buildTextField(
                              label: 'Fecha de nacimiento',
                              value:
                                  _birthDate != null
                                      ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                                      : '',
                              enabled: false,
                              onSaved: (value) {},
                              validator: (value) => null,
                            ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      label: 'Altura (cm)',
                      value: _height.toString(),
                      enabled: _isEditing,
                      keyboardType: TextInputType.number,
                      onSaved:
                          (value) => _height = double.tryParse(value!) ?? 0,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildTextField(
                      label: 'Peso (kg)',
                      value: _peso.toString(),
                      enabled: _isEditing,
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _peso = double.tryParse(value!) ?? 0,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (!_isEditing) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notificaciones'),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: const Text('Modo oscuro'),
                  trailing: ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeNotifier,
                    builder: (context, mode, _) {
                      return Switch(
                        value: mode == ThemeMode.dark,
                        onChanged: (value) {
                          themeNotifier.value =
                              value ? ThemeMode.dark : ThemeMode.light;
                        },
                        activeColor: Theme.of(context).primaryColor,
                      );
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Idioma'),
                  subtitle: const Text('Español'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.question_answer),
                  title: const Text('Actualizar cuestionario'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red.shade400),
                  title: Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.red.shade400),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required String value,
    required bool enabled,
    TextInputType? keyboardType,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: value,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  String _getEdadFromBirthDate(DateTime? date) {
    if (date != null) {
      final now = DateTime.now();
      int age = now.year - date.year;
      if (now.month < date.month ||
          (now.month == date.month && now.day < date.day)) {
        age--;
      }
      return age.toString();
    }
    return '';
  }
}
