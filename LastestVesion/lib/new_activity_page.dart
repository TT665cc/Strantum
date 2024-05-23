import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewActivityPage extends StatefulWidget {
  const NewActivityPage({Key? key}) : super(key: key);

  @override
  _NewActivityPageState createState() => _NewActivityPageState();
}

class _NewActivityPageState extends State<NewActivityPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstInputController = TextEditingController();
  final TextEditingController _secondInputController = TextEditingController();
  final TextEditingController _thirdInputController = TextEditingController();
  final TextEditingController _distanceInputController = TextEditingController();
  final TextEditingController _altitudeInputController = TextEditingController();
  final TextEditingController _windInputController = TextEditingController();

  @override
  void dispose() {
    _firstInputController.dispose();
    _secondInputController.dispose();
    _thirdInputController.dispose();
    _distanceInputController.dispose();
    _altitudeInputController.dispose();
    _windInputController.dispose();
    super.dispose();
  }

  void _printInputValues() {
    if (_formKey.currentState!.validate()) {
      CollectionReference activitiesRef = FirebaseFirestore.instance.collection("Activities");
      activitiesRef.add({
        'title': _firstInputController.text,
        'description': _secondInputController.text,
        'image': _thirdInputController.text,
        'distance': _distanceInputController.text,
        'altitude': _altitudeInputController.text,
        'wind': _windInputController.text,
      });
      FocusScope.of(context).unfocus(); // Ferme le clavier
      _showSnackBar(); // Affiche le message "traitement en cours"
    }
  }

  void _showSnackBar() {
    final snackBar = SnackBar(
      content: Text('Traitement en cours'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ ne peut pas être vide';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Nouvelle activité",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(_firstInputController, 'Titre'),
              SizedBox(height: 16.0),
              _buildInputField(_secondInputController, 'Description'),
              SizedBox(height: 16.0),
              _buildInputField(_thirdInputController, 'Image'),
              SizedBox(height: 16.0),
              _buildInputField(_distanceInputController, 'Distance'),
              SizedBox(height: 16.0),
              _buildInputField(_altitudeInputController, 'Altitude'),
              SizedBox(height: 16.0),
              _buildInputField(_windInputController, 'Altitude équivalente vent'),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _printInputValues,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: Colors.grey[300], // Fond légèrement gris
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Enregistrer",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Texte en noir
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Image.asset('assets/images/tick.png', height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hintText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
        validator: _validateInput,
      ),
    );
  }
}
