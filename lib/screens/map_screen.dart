import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    required this.initialLocation,
    this.isReadOnly = false,
    Key? key,
  }) : super(key: key);

  final PlaceLocation initialLocation;
  final bool isReadOnly;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _pickedPosition;
  bool _selectedPosition = false;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
      _selectedPosition = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isReadOnly
            ? const Text('fechar')
            : const Text('selecione...'),
        actions: [
          if (!widget.isReadOnly)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _selectedPosition
                  ? () {
                      Navigator.of(context).pop(_pickedPosition);
                    }
                  : null,
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 13,
        ),
        onTap: widget.isReadOnly ? null : _selectPosition,
        markers: _selectedPosition && !widget.isReadOnly
            ? {
                Marker(
                  markerId: const MarkerId('A'),
                  position: _pickedPosition,
                ),
              }
            : {
                Marker(
                  markerId: const MarkerId('A'),
                  position: LatLng(
                    widget.initialLocation.latitude,
                    widget.initialLocation.longitude,
                  ),
                ),
              },
      ),
    );
  }
}
