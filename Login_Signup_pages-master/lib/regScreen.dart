import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _avatar;
  DateTime? _selectedDate;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _avatar = File(pickedFile.path);
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu correo';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? _validateGitHub(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu página de GitHub';
    }
    final urlRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?github\.com\/[A-Za-z0-9_-]+\/?$',
    );
    if (!urlRegex.hasMatch(value)) {
      return 'Ingresa una URL válida de GitHub';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu número de teléfono';
    }
    final phoneRegex = RegExp(r'^\+?(\d[\d -]{8,12}\d)$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Ingresa un número de teléfono válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa una contraseña';
    } else if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  Future<void> _launchGitHubURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL $url';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/rosa.png'), // Asegúrate de tener esta imagen en tu carpeta de assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () => _showImageSourceActionSheet(context),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                        image: _avatar != null
                            ? DecorationImage(
                                image: FileImage(_avatar!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _avatar == null
                          ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre completo',
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            isDense: true,
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu nombre completo';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.email, color: Colors.white),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            isDense: true,
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: _validateEmail,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            isDense: true,
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: _validatePassword,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Número de teléfono',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.phone, color: Colors.white),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            isDense: true,
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: _validatePhone,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _githubController,
                          decoration: InputDecoration(
                            labelText: 'Página de GitHub',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.link, color: Colors.white),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            isDense: true,
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: _validateGitHub,
                          onFieldSubmitted: (value) {
                            if (_validateGitHub(value) == null) {
                              _launchGitHubURL(value);
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Fecha de Nacimiento',
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
                                filled: true,
                                fillColor: Colors.white24,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                isDense: true,
                              ),
                              style: TextStyle(color: Colors.white),
                              controller: TextEditingController(
                                text: _selectedDate == null
                                    ? ''
                                    : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                              ),
                              validator: (value) {
                                if (_selectedDate == null) {
                                  return 'Selecciona tu fecha de nacimiento';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                // Lógica para continuar al siguiente paso
                              }
                            },
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.black)
                                : Text(
                                    'Registrar',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "¿Tienes una cuenta? Inicia sesión",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galería'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Cámara'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class regScreen extends StatefulWidget {
  const regScreen({Key? key}) : super(key: key);

  @override
  _regScreenState createState() => _regScreenState();
}

class _regScreenState extends State<regScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _avatar;
  DateTime? _selectedDate;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _avatar = File(pickedFile.path);
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu correo';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? _validateGitHub(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu página de GitHub';
    }
    final urlRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?github\.com\/[A-Za-z0-9_-]+\/?$',
    );
    if (!urlRegex.hasMatch(value)) {
      return 'Ingresa una URL válida de GitHub';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu número de teléfono';
    }
    final phoneRegex = RegExp(r'^\+?(\d[\d -]{8,12}\d)$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Ingresa un número de teléfono válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa una contraseña';
    } else if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  Future<void> _launchGitHubURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL $url';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/rosa.png'), // Asegúrate de tener esta imagen en tu carpeta de assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () => _showImageSourceActionSheet(context),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                        image: _avatar != null
                            ? DecorationImage(
                                image: FileImage(_avatar!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _avatar == null
                          ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre completo',
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            isDense: true,
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu nombre completo';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.email, color: Colors.white),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            isDense: true,
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: _validateEmail,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            isDense: true,
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: _validatePassword,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Número de teléfono',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.phone, color: Colors.white),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            isDense: true,
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: _validatePhone,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _githubController,
                          decoration: InputDecoration(
                            labelText: 'Página de GitHub',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.link, color: Colors.white),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            isDense: true,
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: _validateGitHub,
                          onFieldSubmitted: (value) {
                            if (_validateGitHub(value) == null) {
                              _launchGitHubURL(value);
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Fecha de Nacimiento',
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
                                filled: true,
                                fillColor: Colors.white24,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                isDense: true,
                              ),
                              style: TextStyle(color: Colors.white),
                              controller: TextEditingController(
                                text: _selectedDate == null
                                    ? ''
                                    : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                              ),
                              validator: (value) {
                                if (_selectedDate == null) {
                                  return 'Selecciona tu fecha de nacimiento';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                // Lógica para continuar al siguiente paso
                              }
                            },
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.black)
                                : Text(
                                    'Registrar',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "¿Tienes una cuenta? Inicia sesión",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galería'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Cámara'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
*/