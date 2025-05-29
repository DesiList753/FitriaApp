import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Campos de información de usuario editables
  String _name = 'Isabel Martínez';
  String _email = 'isabel.martinez@email.com';
  int _age = 28;
  String _gender = 'Mujer';
  double _height = 165;
  double _weight = 62;
  
  bool _isEditing = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Guardar los datos del usuario
                  setState(() {
                    _isEditing = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Perfil actualizado')),
                  );
                }
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
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
                enabled: _isEditing,
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo';
                  }
                  if (!value.contains('@')) {
                    return 'Por favor ingresa un correo válido';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      label: 'Edad',
                      value: _age.toString(),
                      enabled: _isEditing,
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _age = int.tryParse(value!) ?? 0,
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
                      label: 'Género',
                      value: _gender,
                      enabled: _isEditing,
                      onSaved: (value) => _gender = value!,
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
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      label: 'Altura (cm)',
                      value: _height.toString(),
                      enabled: _isEditing,
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _height = double.tryParse(value!) ?? 0,
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
                      value: _weight.toString(),
                      enabled: _isEditing,
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _weight = double.tryParse(value!) ?? 0,
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
                    value: true,
                    onChanged: (value) {},
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: const Text('Modo oscuro'),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Idioma'),
                  subtitle: const Text('Español'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red.shade400),
                  title: Text('Cerrar sesión', 
                    style: TextStyle(color: Colors.red.shade400),
                  ),
                  onTap: () {},
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
}
