import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstInputController = TextEditingController();
  final TextEditingController _secondInputController = TextEditingController();
  double _sliderValue = 6.0;

  @override
  void dispose() {
    _firstInputController.dispose();
    _secondInputController.dispose();
    super.dispose();
  }

  void _show_itineraire() {
    if (_formKey.currentState!.validate()) {
      print('First Input: ${_firstInputController.text}');
      print('Second Input: ${_secondInputController.text}');
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
              "Nouvel Itinéraire",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/desc1.png',
              height: 40,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: _firstInputController,
                  decoration: InputDecoration(
                    hintText: 'Enter your first input',
                    border: InputBorder.none,
                  ),
                  validator: _validateInput,
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: _secondInputController,
                  decoration: InputDecoration(
                    hintText: 'Enter your second input',
                    border: InputBorder.none,
                  ),
                  validator: _validateInput,
                ),
              ),
              SizedBox(height: 32.0),
              Text(
                "Difficulté:",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Column(
                children: [
                  Slider(
                    value: _sliderValue,
                    min: 1,
                    max: 11,
                    divisions: 10,
                    onChanged: (double value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/cool.png', height: 24),
                      Image.asset('assets/images/hard.png', height: 24),
                      Image.asset('assets/images/demon.png', height: 24),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: _show_itineraire,
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
                        "C'est parti !",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Texte en noir
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Image.asset('assets/images/strong.png', height: 24),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0), // Ajout d'un espacement au-dessus de l'image
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0), // Espacement autour de l'image
                  child: Image.asset('assets/images/map1.png', fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}