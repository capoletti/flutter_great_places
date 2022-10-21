import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/widgets/image_input.dart';
import 'package:great_places/widgets/location_input.dart';
import 'package:provider/provider.dart';

class PlaceFormSreen extends StatefulWidget {
  const PlaceFormSreen({Key? key}) : super(key: key);

  @override
  State<PlaceFormSreen> createState() => _PlaceFormSreenState();
}

class _PlaceFormSreenState extends State<PlaceFormSreen> {
  final _titleController = TextEditingController();
  late File _pickedImage;
  late LatLng _pickedPosition;
  bool _hasFile = false;

  void _selectedImage(File pickedImage) {
    _pickedImage = pickedImage;
    _hasFile = true;
  }

  void _selectPosition(LatLng position) {
    _pickedPosition = position;
  }

  void _submitForm() {
    if (_titleController.text.isEmpty || !_hasFile) {
      return;
    }

    Provider.of<GreatPlaces>(context, listen: false).addPlace(
      _titleController.text,
      _pickedImage,
      _pickedPosition,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Lugar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ImageInput(onSelectImage: _selectedImage),
                    const SizedBox(height: 10),
                    LocationInput(onSelectPosition: _selectPosition),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _submitForm,
            icon: const Icon(Icons.add),
            label: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
