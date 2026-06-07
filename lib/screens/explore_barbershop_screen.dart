import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'queue_status_screen.dart';

class ExploreBarbershopScreen extends StatefulWidget {
  const ExploreBarbershopScreen({super.key});

  @override
  State<ExploreBarbershopScreen> createState() => _ExploreBarbershopScreenState();
}

class _ExploreBarbershopScreenState extends State<ExploreBarbershopScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  bool _isLoadingLocation = true;
  bool _permissionDenied = false;
  
  int _selectedBarberIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  // Data Barbershop Lengkap dengan Koordinat LatLng
  final List<Map<String, dynamic>> _barbers = [
    {
      'name': 'The Heritage Shop',
      'distance': '0.8 km',
      'rating': 4.9,
      'status': 'Open',
      'address': 'Jl. Kemang Raya No. 12, Jakarta',
      'image': 'https://images.unsplash.com/photo-1621605815971-fbc98d665033?auto=format&fit=crop&w=600&q=80',
      'latlng': const LatLng(-6.2030, 106.8186), // Default placeholder, akan di-update relatif terhadap user
    },
    {
      'name': "Gentle's Cut",
      'distance': '1.2 km',
      'rating': 4.8,
      'status': 'Open',
      'address': 'Jl. Senopati No. 45, Jakarta',
      'image': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&w=600&q=80',
      'latlng': const LatLng(-6.1970, 106.8206),
    },
    {
      'name': 'Gold Cut Studio',
      'distance': '2.0 km',
      'rating': 4.7,
      'status': 'Closed',
      'address': 'Jl. Sudirman Kav 21, Jakarta',
      'image': 'https://images.unsplash.com/photo-1593702275687-f8b402bf1fb5?auto=format&fit=crop&w=600&q=80',
      'latlng': const LatLng(-6.2010, 106.8126),
    },
    {
      'name': 'Barber King Kemang',
      'distance': '2.5 km',
      'rating': 4.6,
      'status': 'Open',
      'address': 'Jl. Bangka Raya No. 8, Jakarta',
      'image': 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?auto=format&fit=crop&w=600&q=80',
      'latlng': const LatLng(-6.2050, 106.8146),
    },
    {
      'name': 'Classic & Co. Barber',
      'distance': '3.1 km',
      'rating': 4.9,
      'status': 'Open',
      'address': 'Jl. Wijaya II No. 34, Jakarta',
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=600&q=80',
      'latlng': const LatLng(-6.1950, 106.8156),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initLocationAndMarkers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  /// Memulai proses geolokasi dan konfigurasi marker peta
  Future<void> _initLocationAndMarkers() async {
    try {
      final position = await _determinePosition();
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
        _permissionDenied = false;
        _setupMarkers(position);
      });
      _animateToPosition(position);
    } catch (e) {
      debugPrint('Error getting location for explore page: $e');
      setState(() {
        _isLoadingLocation = false;
        _permissionDenied = true;
        // Lokasi default Jakarta (-6.2000, 106.8166) jika izin ditolak
        final defaultPosition = Position(
          latitude: -6.2000,
          longitude: 106.8166,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
        _currentPosition = defaultPosition;
        _setupMarkers(defaultPosition);
      });
    }
  }

  /// Meminta izin lokasi ke pengguna
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } 

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Membuat Marker di sekitar posisi pengguna dan memperbarui koordinat barbershop secara dinamis
  void _setupMarkers(Position position) {
    final Set<Marker> tempMarkers = {};
    
    // 1. Marker Posisi Pengguna (Biru)
    tempMarkers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'Posisi Anda'),
      ),
    );

    // Offsets koordinat simulasi untuk barbershop di sekitar pengguna
    final List<LatLng> offsets = [
      LatLng(position.latitude + 0.003, position.longitude + 0.002),
      LatLng(position.latitude - 0.002, position.longitude + 0.004),
      LatLng(position.latitude + 0.001, position.longitude - 0.003),
      LatLng(position.latitude + 0.005, position.longitude + 0.001),
      LatLng(position.latitude - 0.004, position.longitude - 0.002),
    ];

    // 2. Marker Emas (Custom Gold/Yellow Hue 42.0) untuk Barbershops
    for (int i = 0; i < _barbers.length; i++) {
      final barber = _barbers[i];
      // Perbarui koordinat dinamis agar selalu di sekitar user
      barber['latlng'] = offsets[i];

      tempMarkers.add(
        Marker(
          markerId: MarkerId('barber_$i'),
          position: offsets[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(42.0),
          onTap: () {
            setState(() {
              _selectedBarberIndex = i;
            });
            _pageController.animateToPage(
              i,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(offsets[i]),
            );
          },
          infoWindow: InfoWindow(
            title: barber['name'],
            snippet: '${barber['distance']} • Rating: ${barber['rating']}',
          ),
        ),
      );
    }

    setState(() {
      _markers = tempMarkers;
    });
  }

  void _animateToPosition(Position position) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14.5,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'EXPLORE BARBERSHOP',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Color(0xFFD4AF37)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Toggle View: Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white70,
                labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13),
                unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13),
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_alt_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('List View'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Map View'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab View Body
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(), // Nonaktifkan swipe agar tidak bentrok dengan map gesture
                children: [
                  _buildListView(),
                  _buildMapView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LIST VIEW LAYOUT =================
  Widget _buildListView() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: _barbers.length,
      itemBuilder: (context, index) {
        final barber = _barbers[index];
        final bool isOpen = barber['status'] == 'Open';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.03)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Interior Outlet
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      barber['image'],
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Status Tag (Open / Closed)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isOpen ? Colors.green.withOpacity(0.9) : Colors.redAccent.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isOpen ? 'OPEN' : 'CLOSED',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  // Rating Tag
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFD4AF37), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            barber['rating'].toString(),
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Detail Deskripsi
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            barber['name'],
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: Color(0xFFD4AF37), size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${barber['distance']} • ${barber['address']}',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const QueueStatusScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Book',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= MAP VIEW LAYOUT =================
  Widget _buildMapView() {
    return Stack(
      children: [
        // 1. Google Map Fullscreen
        if (_currentPosition != null)
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              zoom: 14.5,
            ),
            markers: _markers,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _mapController!.setMapStyle(_mapDarkStyle);
            },
          )
        else
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
            ),
          ),

        // 2. Warning Izin Lokasi Ditolak
        if (_permissionDenied)
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Izin lokasi ditolak. Menampilkan lokasi default.',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // 3. Horizontal Scrollable Cards
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          height: 120,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _barbers.length,
            onPageChanged: (int index) {
              setState(() {
                _selectedBarberIndex = index;
              });
              // Geser kamera peta ke koordinat barbershop yang dipilih
              _mapController?.animateCamera(
                CameraUpdate.newLatLng(_barbers[index]['latlng']),
              );
            },
            itemBuilder: (context, index) {
              final barber = _barbers[index];
              final bool isSelected = index == _selectedBarberIndex;
              final bool isOpen = barber['status'] == 'Open';

              return GestureDetector(
                onTap: () {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLng(barber['latlng']),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFD4AF37) : Colors.white.withOpacity(0.05),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          barber['image'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    barber['name'],
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isOpen ? Colors.green.withOpacity(0.2) : Colors.redAccent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: isOpen ? Colors.green.withOpacity(0.4) : Colors.redAccent.withOpacity(0.4),
                                    ),
                                  ),
                                  child: Text(
                                    isOpen ? 'OPEN' : 'CLOSED',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: isOpen ? Colors.green : Colors.redAccent,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              barber['address'],
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white38,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, color: Color(0xFFD4AF37), size: 12),
                                    const SizedBox(width: 2),
                                    Text(
                                      barber['distance'],
                                      style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 10),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.star, color: Color(0xFFD4AF37), size: 12),
                                    const SizedBox(width: 2),
                                    Text(
                                      barber['rating'].toString(),
                                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const QueueStatusScreen()),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD4AF37),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Book',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.black,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Google Maps Dark Style (JSON format)
  static const String _mapDarkStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#181818"
        }
      ]
    },
    {
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#212121"
        }
      ]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "administrative.country",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9e9e9e"
        }
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#bdbdbd"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#121212"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#1b1b1b"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#2c2c2c"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#8a8a8a"
        }
      ]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#373737"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#3c3c3c"
        }
      ]
    },
    {
      "featureType": "road.highway.controlled_access",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#4e4e4e"
        }
      ]
    },
    {
      "featureType": "road.local",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#000000"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#3d3d3d"
        }
      ]
    }
  ]
  ''';
}
