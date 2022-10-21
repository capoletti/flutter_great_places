import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:great_places/utils/location_util.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({required this.onSelectPosition, Key? key})
      : super(key: key);

  final Function onSelectPosition;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl = '';

  Future<void> _getCurrentUserLocation() async {
    final locationData = await Location().getLocation();
    final staticMap = LocationUtil.generateLocationImage(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
    );

    final LatLng selectedLocation = LatLng(
      locationData.latitude!,
      locationData.longitude!,
    );

    setState(() {
      widget.onSelectPosition(selectedLocation);
      _previewImageUrl = staticMap;
    });
  }

  Future<void> _selectOnMap() async {
    final locationData = await Location().getLocation();
    final initialLocation = PlaceLocation(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
      address: '',
    );

    final LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (cxt) => MapScreen(initialLocation: initialLocation),
      ),
    );

    final staticMap = LocationUtil.generateLocationImage(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    );

    setState(() {
      widget.onSelectPosition(selectedLocation);
      _previewImageUrl = staticMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl.isEmpty
              ? const Text('Localização não informada!')
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Localização atual'),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Selecione no mapa'),
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
