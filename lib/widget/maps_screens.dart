import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample>
    with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kCartagena = CameraPosition(
    target: LatLng(10.4231, -75.5280), // Coordenadas de Cartagena de Indias
    zoom: 14.0,
  );

  Polyline _routePolyline() {
    return Polyline(
      polylineId: PolylineId("route"),
      color: Colors.green,
      points: [
        LatLng(10.4231, -75.5280), // Centro histórico de Cartagena
        LatLng(10.4300, -75.5393), // Punto intermedio
        LatLng(10.4287, -75.5442), // Punto intermedio
        LatLng(10.4258, -75.5501), // Plaza Colón
      ],
    );
  }

  Marker _createMarker(String markerId, double lat, double lng, String title,
      BitmapDescriptor descriptor) {
    return Marker(
      markerId: MarkerId(markerId),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title),
      icon: descriptor,
    );
  }

  late AnimationController _animationController;
  late LatLng _currentPosition;
  late List<LatLng> _points;
  late Timer _timer;
  int _currentMarkerIndex = 0;
  late Set<Marker> _markers;
  late Set<Polyline> _polylines;

  @override
  void initState() {
    super.initState();

    _points = _routePolyline().points;
    _currentPosition = _points.first;
    _markers = {
      _createMarker(
        "PlazaColon",
        10.4258,
        -75.5501,
        "Plaza Colón",
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      _createMarker(
        "CentroHistorico",
        10.4231,
        -75.5280,
        "Centro Histórico",
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    };
    _polylines = {
      _routePolyline(),
    };

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    _animationController.addListener(() {
      final double animationValue = _animationController.value;
      final int index = (_currentMarkerIndex + animationValue).floor();
      if (index < _points.length) {
        _currentPosition = _points[index];
        _updateMarkers();
        _updatePolylines(index);
      } else {
        _timer.cancel();
      }
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _animationController.forward(from: 0.0);
      _currentMarkerIndex += 1;
    });
  }

  void _updateMarkers() {
    setState(() {
      _markers.removeWhere(
        (marker) => marker.markerId.value == "CentroHistorico",
      ); // Elimina el marcador anterior
      _markers.add(
        _createMarker(
          "CentroHistorico",
          _currentPosition.latitude,
          _currentPosition.longitude,
          "Centro Histórico",
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });

    _controller.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newLatLng(_currentPosition),
      );
    });
  }

  void _updatePolylines(int index) {
    setState(() {
      // Elimina la sección de la ruta ya recorrida
      _polylines.removeWhere(
        (polyline) => polyline.polylineId.value == "route",
      );
      _polylines
          .add(_partialRoutePolyline(index)); // Agrega la ruta actualizada
    });
  }

  Polyline _partialRoutePolyline(int index) {
    return Polyline(
      polylineId: PolylineId("route"),
      color: Colors.green,
      points: _points.sublist(0, index + 1),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kCartagena,
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Detener'),
        icon: const Icon(Icons.stop),
      ),
    );
  }
}
