import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class KlikCutBookingPage extends StatefulWidget {
  const KlikCutBookingPage({super.key});

  @override
  State<KlikCutBookingPage> createState() => _KlikCutBookingPageState();
}

class _KlikCutBookingPageState extends State<KlikCutBookingPage> {
  String _selectedService = 'Executive Cut';
  String _selectedBarber = 'Hisyam';
  late String _selectedDate;
  String _selectedTime = '13:00';

  late List<String> _dates;

  final List<Map<String, dynamic>> _services = [
    {'name': 'Executive Cut', 'price': 'Rp 150.000', 'priceValue': 150000, 'duration': '45 mins'},
    {'name': 'Classic Cut', 'price': 'Rp 90.000', 'priceValue': 90000, 'duration': '30 mins'},
    {'name': 'Signature Shave', 'price': 'Rp 75.000', 'priceValue': 75000, 'duration': '30 mins'},
    {'name': 'Hair & Beard Spa', 'price': 'Rp 200.000', 'priceValue': 200000, 'duration': '60 mins'},
  ];

  final List<Map<String, dynamic>> _barbers = [
    {
      'name': 'Hisyam',
      'role': 'Master Barber',
      'rating': 4.9,
      'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80'
    },
    {
      'name': 'Sufyan',
      'role': 'Senior Barber',
      'rating': 4.8,
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=250&q=80'
    },
    {
      'name': 'Ahmad',
      'role': 'Hair Stylist',
      'rating': 4.7,
      'image': 'https://images.unsplash.com/photo-1628157582853-a796fa650a6a?auto=format&fit=crop&w=250&q=80'
    },
  ];

  final List<String> _timeSlots = [
    '09:00', '10:30', '11:30', '13:00', '14:30', '16:00', '17:30', '19:00', '20:30'
  ];

  @override
  void initState() {
    super.initState();
    _dates = _generateDynamicDates();
    _selectedDate = _dates.first;
  }

  List<String> _generateDynamicDates() {
    final List<String> dates = [];
    final now = DateTime.now();
    final isEn = appLocaleNotifier.value.languageCode == 'en';
    
    final daysOfWeek = isEn 
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
        
    final months = isEn
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        : ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
        
    for (int i = 0; i < 5; i++) {
      final date = now.add(Duration(days: i));
      String prefix = '';
      if (i == 0) {
        prefix = isEn ? 'Today' : 'Hari Ini';
      } else if (i == 1) {
        prefix = isEn ? 'Tomorrow' : 'Besok';
      } else {
        prefix = daysOfWeek[date.weekday - 1];
      }
      dates.add('$prefix, ${date.day} ${months[date.month - 1]}');
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Solid luxury black
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'BOOKING KLIKCUT',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFFD4AF37), // Metallic Gold
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          children: [
            const SizedBox(height: 12),
            _buildSectionHeader('Select Service'),
            const SizedBox(height: 10),
            _buildServicesList(),
            const SizedBox(height: 24),
            _buildSectionHeader('Select Barber'),
            const SizedBox(height: 10),
            _buildBarbersList(),
            const SizedBox(height: 24),
            _buildSectionHeader('Select Date'),
            const SizedBox(height: 10),
            _buildDateList(),
            const SizedBox(height: 24),
            _buildSectionHeader('Select Time Slot'),
            const SizedBox(height: 10),
            _buildTimeSlotsGrid(),
            const SizedBox(height: 36),
            _buildConfirmButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        color: const Color(0xFFD4AF37).withOpacity(0.8),
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildServicesList() {
    return Column(
      children: _services.map((service) {
        final bool isSelected = service['name'] == _selectedService;
        return GestureDetector(
          onTap: () => setState(() => _selectedService = service['name']),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFFD4AF37) : Colors.white.withOpacity(0.02),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFD4AF37).withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['name'],
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service['duration'],
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                Text(
                  service['price'],
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFD4AF37),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBarbersList() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _barbers.length,
        itemBuilder: (context, index) {
          final barber = _barbers[index];
          final bool isSelected = barber['name'] == _selectedBarber;

          return GestureDetector(
            onTap: () => setState(() => _selectedBarber = barber['name']),
            child: Container(
              width: 180,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? const Color(0xFFD4AF37) : Colors.white.withOpacity(0.02),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(barber['image']),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          barber['name'],
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          barber['role'],
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFD4AF37), size: 12),
                            const SizedBox(width: 2),
                            Text(
                              barber['rating'].toString(),
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildDateList() {
    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          final date = _dates[index];
          final bool isSelected = date == _selectedDate;

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFF141414),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.05),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                date,
                style: GoogleFonts.plusJakartaSans(
                  color: isSelected ? Colors.black : Colors.white70,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlotsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.2,
      ),
      itemCount: _timeSlots.length,
      itemBuilder: (context, index) {
        final time = _timeSlots[index];
        final bool isSelected = time == _selectedTime;

        return GestureDetector(
          onTap: () => setState(() => _selectedTime = time),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFF141414),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.05),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              time,
              style: GoogleFonts.plusJakartaSans(
                color: isSelected ? Colors.black : Colors.white70,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFC5A028)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          final selectedServiceObj = _services.firstWhere((s) => s['name'] == _selectedService);
          final int servicePrice = selectedServiceObj['priceValue'] as int;

          if (userBalanceNotifier.value < servicePrice) {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: const Color(0xFF141414),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
                      const SizedBox(height: 20),
                      Text(
                        'Insufficient Balance',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your KlikPay balance is not enough for this booking. Please top up first.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'OK',
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            return;
          }

          // Deduct balance
          userBalanceNotifier.value -= servicePrice;

          // Add to transactions
          final newTx = {
            'title': 'KlikCut Booking: $_selectedService',
            'subtitle': _getCurrentFormattedDate(),
            'value': '-Rp ${NumberFormat.decimalPattern('id').format(servicePrice)}',
            'isNegative': true,
            'icon': Icons.content_cut_rounded,
          };
          transactionsNotifier.value = [newTx, ...transactionsNotifier.value];

          // Set active booking
          activeBookingNotifier.value = {
            'serviceName': _selectedService,
            'barberName': _selectedBarber,
            'date': _selectedDate,
            'time': _selectedTime,
            'price': servicePrice,
            'queueNumber': '#A-15',
            'estWaitTime': 25,
          };

          // Tampilkan Booking Success dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Dialog(
              backgroundColor: const Color(0xFF141414),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFFD4AF37),
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Booking Success!',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your KlikCut service has been booked with $_selectedBarber for $_selectedDate at $_selectedTime.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog
                          Navigator.of(context).pop(); // Kembali ke halaman Home
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Back to Home',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          'Confirm Booking',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  String _getCurrentFormattedDate() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${now.day} ${months[now.month - 1]}';
  }
}

