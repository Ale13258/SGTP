import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample>
    with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kPlazaColon = CameraPosition(
    target: LatLng(10.3997200, -75.5144400),
    zoom: 13.0,
  );

  late AnimationController _animationController;
  late LatLng _currentPosition;
  late List<LatLng> _points;
  late Timer _timer;
  int _currentMarkerIndex = 0;
  late Set<Marker> _markers;
  late Set<Polyline> _polylines;
  late bool _isRunning = false;

  late Set<Marker> _smallMarkers;
  late List<LatLng> _stopPoints;

  @override
  void initState() {
    super.initState();

    // Cambia estas coordenadas según la ruta del Transcaribe que hayas elegido
    _points = [
      LatLng(10.390709, -75.496336),
      LatLng(10.395, -75.480), // Parada adicional 1
      LatLng(10.398, -75.475), // Parada adicional 2
      LatLng(10.402, -75.470), // Parada adicional 3
      LatLng(10.405, -75.465), // Parada adicional 4
      LatLng(10.400346, -75.458832), // Centro Recreacional Napoleón Perea
    ];

    _currentPosition = _points.first;
    _markers = {
      _createMarker(
        "ruta1",
        10.390709,
        -75.496336,
        "Ubicacion actual",
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      _createMarker(
        "ruta2",
        10.400346,
        -75.458832,
        "Destino",
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    };
    _polylines = {
      _routePolyline(),
    };

    _smallMarkers = {};
    _stopPoints = [
      LatLng(10.41261665, -75.524661837412),
      LatLng(10.400346, -75.458832),
    ];

    _animationController = AnimationController(
      vsync: this,
      duration:
          Duration(seconds: 60), // Aumentar la duración para hacerlo más lento
    );

    _animationController.addListener(() {
      final double animationValue = _animationController.value;
      final int index = (_currentMarkerIndex + animationValue).floor();
      if (index < _points.length) {
        _currentPosition = _points[index];
        _updateMarkers();
        _updatePolylines(index);
        _updateSmallMarkers(index);
        _updateStopPoints(index);
      } else {
        _timer.cancel();
        // Llegaste al destino
        _markers.add(
          _createMarker(
            "DestinationMarker",
            _currentPosition.latitude,
            _currentPosition.longitude,
            "¡Haz llegado a tu destino!",
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          ),
        );
        _showDestinationReachedMessage();
      }
    });

    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (_isRunning) {
        _animationController.forward(from: 0.0);
        _currentMarkerIndex += 1;
      }
    });
  }

  Polyline _routePolyline() {
    return Polyline(
      polylineId: PolylineId("route"),
      color: Colors.green,
      points: _points,
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

  void _updateMarkers() {
    setState(() {
      _markers.removeWhere(
        (marker) =>
            marker.markerId.value == "PlazaColon" ||
            marker.markerId.value == "Santillana" ||
            marker.markerId.value == "MovingMarker" ||
            marker.markerId.value == "DestinationMarker",
      );

      String markerTitle;
      if (_currentMarkerIndex == 0) {
        markerTitle = "Ubicación actual";
      } else if (_currentMarkerIndex == _points.length - 1) {
        markerTitle = "Ubicación destino";
      } else {
        markerTitle = "Punto intermedio";
      }

      _markers.add(
        _createMarker(
          "MovingMarker",
          _currentPosition.latitude,
          _currentPosition.longitude,
          markerTitle,
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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
      _polylines.removeWhere(
        (polyline) => polyline.polylineId.value == "route",
      );
      _polylines.add(_partialRoutePolyline(index));
    });
  }

  void _updateSmallMarkers(int index) {
    for (int i = 0; i < _smallMarkers.length; i++) {
      final double distance = _calculateDistance(
        _currentPosition.latitude,
        _currentPosition.longitude,
        _smallMarkers.elementAt(i).position.latitude,
        _smallMarkers.elementAt(i).position.longitude,
      );

      if (distance < 0.01) {
        setState(() {
          _smallMarkers.remove(_smallMarkers.elementAt(i));
        });
      }
    }

    if (index > 0 && index < _points.length - 1) {
      final double distanceToNextPoint = _calculateDistance(
        _points[index - 1].latitude,
        _points[index - 1].longitude,
        _currentPosition.latitude,
        _currentPosition.longitude,
      );

      if (distanceToNextPoint < 0.01) {
        setState(() {
          _smallMarkers.add(
            _createMarker(
              "SmallMarker${_smallMarkers.length + 1}",
              _points[index].latitude,
              _points[index].longitude,
              "Small Marker",
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            ),
          );
        });
      }
    }
  }

  void _updateStopPoints(int index) {
    for (int i = 0; i < _stopPoints.length; i++) {
      final double distance = _calculateDistance(
        _currentPosition.latitude,
        _currentPosition.longitude,
        _stopPoints[i].latitude,
        _stopPoints[i].longitude,
      );

      if (distance < 0.005) {
        // Quitar la parada cuando estás muy cerca (5 metros)
        setState(() {
          _stopPoints.removeAt(i);
          _markers.removeWhere(
            (marker) => marker.markerId.value == "StopMarker$i",
          );
        });

        // Verificar si llegaste a la última parada
        if (_stopPoints.isEmpty) {
          _showDestinationReachedMessage();
        }
      } else if (distance < 0.01 * (index + 1)) {
        // Quitar las paradas después de 10 metros y hasta la última
        setState(() {
          _stopPoints.removeAt(i);
          _markers.removeWhere(
            (marker) => marker.markerId.value == "StopMarker$i",
          );
        });

        // Verificar si llegaste a la última parada
        if (_stopPoints.isEmpty) {
          _showDestinationReachedMessage();
        }
      }
    }
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

  double _calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    const double radius = 6371.0;

    double startLatRad = startLatitude * (pi / 180.0);
    double startLonRad = startLongitude * (pi / 180.0);
    double endLatRad = endLatitude * (pi / 180.0);
    double endLonRad = endLongitude * (pi / 180.0);

    double latDiff = endLatRad - startLatRad;
    double lonDiff = endLonRad - startLonRad;

    double a = (sin(latDiff / 2) * sin(latDiff / 2)) +
        (cos(startLatRad) *
            cos(endLatRad) *
            sin(lonDiff / 2) *
            sin(lonDiff / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radius * c;

    return distance;
  }

  String _calculateEstimatedArrivalTime() {
    // Velocidad promedio en km/h (ajustada para hacerlo más lento)
    const double averageSpeed = 10.0;
    // Calcular tiempo en horas
    double totalDistance = 0.0;
    for (int i = 1; i < _points.length; i++) {
      totalDistance += _calculateDistance(
        _points[i - 1].latitude,
        _points[i - 1].longitude,
        _points[i].latitude,
        _points[i].longitude,
      );
    }
    double timeInHours = totalDistance / averageSpeed;
    // Convertir tiempo a minutos
    int timeInMinutes = (timeInHours * 60).ceil();

    // Calcular hora de llegada estimada
    DateTime now = DateTime.now().toUtc(); // Obtener hora actual en UTC
    DateTime estimatedArrivalTime = now.add(Duration(minutes: timeInMinutes));

    // Ajustar a la zona horaria de Colombia (GMT-5)
    estimatedArrivalTime = estimatedArrivalTime.subtract(Duration(hours: 5));

    // Formatear la hora
    String formattedTime = DateFormat.jm().format(estimatedArrivalTime);

    return formattedTime;
  }

  void _showDestinationReachedMessage() {
    print("Llegaste al destino");
    Fluttertoast.showToast(
      msg: "¡Has llegado a tu destino!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kPlazaColon,
            markers: _markers.union(_smallMarkers),
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hora estimada de llegada:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _calculateEstimatedArrivalTime(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Paradas:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  for (int i = 0; i < _stopPoints.length; i++)
                    if (_stopPoints.length - i <= _stopPoints.length)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Text('Parada ${i + 1}'),
                        ],
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _isRunning = !_isRunning;

            if (_isRunning) {
              _animationController.reset();
              _animationController.forward();
            }
          });
        },
        label: Text(_isRunning ? 'Detener' : 'Empezar'),
        icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
      ),
    );
  }
}
