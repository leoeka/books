import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Future<Position>? position;

  @override
  void initState() {
    super.initState();
    // Menetapkan future untuk mendapatkan posisi
    position = getPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Current Location')),
      body: Center(
        child: FutureBuilder<Position>(
          future: position,
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              // Menambahkan pengecekan error
              if (snapshot.hasError) {
                return const Text('Something terrible happened!');
              }
              // Jika posisi berhasil didapatkan, tampilkan hasilnya
              return Text(
                'Latitude: ${snapshot.data!.latitude} - Longitude: ${snapshot.data!.longitude}',
                style: const TextStyle(fontSize: 16),
              );
            } else {
              return const Text('Error fetching location');
            }
          },
        ),
      ),
    );
  }

  Future<Position> getPosition() async {
    // Memastikan layanan lokasi diaktifkan
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Jika layanan lokasi tidak aktif
      throw 'Location services are disabled.';
    }

    // Mendapatkan posisi saat ini
    await Future.delayed(const Duration(seconds: 3));
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
