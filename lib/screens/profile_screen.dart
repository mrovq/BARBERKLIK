import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import 'home_screen.dart';
import 'klikmart_screen.dart';
import 'queue_status_screen.dart';
import 'wallet_screen.dart';
import 'splash_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _fullName = 'Moh. Rofiqi A.Z';
  String _username = 'rofiqiaz';
  String _email = 'rofiqi.az@gmail.com';
  String _phone = '+62 812-3456-7890';

  final List<Map<String, dynamic>> _savedAddresses = [
    {
      'label': 'Home',
      'address': 'Jl. Senopati No. 12, Kebayoran Baru, Jakarta Selatan',
      'isPrimary': true,
    },
    {
      'label': 'Office',
      'address': 'Menara Astra Lt. 15, Jl. Jend. Sudirman, Jakarta Pusat',
      'isPrimary': false,
    },
  ];

  final List<Map<String, dynamic>> _paymentCards = [
    {
      'type': 'MasterCard',
      'number': '•••• •••• •••• 4582',
      'expiry': '12/28',
      'holder': 'Moh. Rofiqi A.Z',
    },
    {
      'type': 'Visa',
      'number': '•••• •••• •••• 9018',
      'expiry': '08/29',
      'holder': 'Moh. Rofiqi A.Z',
    },
  ];
  /// Fungsi asynchronous untuk mengambil foto dari galeri menggunakan package image_picker.
  /// Setelah foto berhasil dipilih, bytes gambar akan dibaca dan notifier global userProfileImageNotifier diperbarui.
  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Mengompresi kualitas gambar (85%) untuk optimasi performa & memori
      );

      if (pickedFile != null) {
        // Membaca bytes gambar secara asynchronous agar kompatibel di web & mobile
        final Uint8List bytes = await pickedFile.readAsBytes();
        userProfileImageNotifier.value = bytes;
      }
    } catch (e) {
      // Menangkap error jika terjadi kesalahan akses galeri atau pemilihan foto
      debugPrint('Error picking image from gallery: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Luxurious solid black #0A0A0A
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        title: Text(
          l10n.profile,
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFFD4AF37), // Gold
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Color(0xFFD4AF37),
            ),
            onPressed: _showAccountSettingsBottomSheet,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          children: [
            const SizedBox(height: 16),
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildPointsCard(),
            const SizedBox(height: 28),
            _buildSectionHeader(l10n.accountManagement),
            const SizedBox(height: 10),
            _buildMenuItem(Icons.account_balance_wallet_outlined, l10n.myWallet, () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const WalletScreen()),
              );
            }),
            _buildMenuItem(Icons.history_rounded, l10n.bookingHistory, _showBookingHistoryBottomSheet),
            _buildMenuItem(Icons.location_on_outlined, l10n.savedAddresses, _showSavedAddressesBottomSheet),
            _buildMenuItem(Icons.credit_card_rounded, l10n.paymentMethods, _showPaymentMethodsBottomSheet),
            
            // Dropdown Pilihan Bahasa bertema Luxury Dark Mode
            _buildLanguageMenuItem(),
            
            const SizedBox(height: 24),
            _buildSectionHeader(l10n.securityAndSupport),
            const SizedBox(height: 10),
            _buildMenuItem(Icons.security_rounded, l10n.securitySettings, _showSecuritySettingsBottomSheet),
            _buildMenuItem(Icons.help_outline_rounded, l10n.helpCenter, _showHelpCenterBottomSheet),
            const SizedBox(height: 32),
            _buildLogoutButton(),
            const SizedBox(height: 120), // Padding above bottom navigation bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // --- PROFILE INTERACTIONS & SHEETS ---

  void _showAccountSettingsBottomSheet() {
    final TextEditingController nameController = TextEditingController(text: _fullName);
    final TextEditingController usernameController = TextEditingController(text: _username);
    final TextEditingController emailController = TextEditingController(text: _email);
    final TextEditingController phoneController = TextEditingController(text: _phone);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Account Settings',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFD4AF37),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Full Name',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: nameController,
                      style: GoogleFonts.plusJakartaSans(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF0A0A0A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Name cannot be empty' : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Username',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: usernameController,
                      style: GoogleFonts.plusJakartaSans(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF0A0A0A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Username cannot be empty' : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Email Address',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: emailController,
                      style: GoogleFonts.plusJakartaSans(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF0A0A0A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email cannot be empty';
                        if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Phone Number',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: phoneController,
                      style: GoogleFonts.plusJakartaSans(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF0A0A0A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Phone cannot be empty' : null,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          setState(() {
                            _fullName = nameController.text.trim();
                            _username = usernameController.text.trim();
                            _email = emailController.text.trim();
                            _phone = phoneController.text.trim();
                          });
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Profile updated successfully!', style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.bold)),
                              backgroundColor: const Color(0xFFD4AF37),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Save Changes', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBookingHistoryBottomSheet() {
    final List<Map<String, dynamic>> mockHistory = [
      {
        'service': 'Gentleman\'s Cut & Wash',
        'barber': 'Rian H.',
        'date': '24 Mei 2026',
        'price': 'Rp 85.000',
        'status': 'Completed',
        'icon': Icons.content_cut_rounded,
      },
      {
        'service': 'KlikCut: Premium Shave',
        'barber': 'Dedi S.',
        'date': '10 Apr 2026',
        'price': 'Rp 60.000',
        'status': 'Completed',
        'icon': Icons.face_retouching_natural_rounded,
      },
      {
        'service': 'KlikMart: Hair Pomade Matte',
        'barber': 'Store Delivery',
        'date': '28 Mar 2026',
        'price': 'Rp 120.000',
        'status': 'Completed',
        'icon': Icons.shopping_bag_outlined,
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Booking History',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFD4AF37),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: mockHistory.length,
                  itemBuilder: (context, index) {
                    final item = mockHistory[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.03)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141414),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(item['icon'] as IconData, color: const Color(0xFFD4AF37), size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['service'],
                                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Barber: ${item['barber']} • ${item['date']}',
                                  style: GoogleFonts.plusJakartaSans(color: Colors.white30, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                item['price'],
                                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item['status'],
                                  style: GoogleFonts.plusJakartaSans(color: Colors.green, fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSavedAddressesBottomSheet() {
    final TextEditingController labelController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
    bool isAdding = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            if (isAdding) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: 24.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
                ),
                child: Form(
                  key: addressFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Add New Address',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFD4AF37),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Address Label (e.g. Home, Office, Apartment)',
                        style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: labelController,
                        style: GoogleFonts.plusJakartaSans(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Home',
                          hintStyle: GoogleFonts.plusJakartaSans(color: Colors.white24),
                          filled: true,
                          fillColor: const Color(0xFF0A0A0A),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Label cannot be empty' : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Full Address Details',
                        style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: addressController,
                        maxLines: 3,
                        style: GoogleFonts.plusJakartaSans(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Jl. Boulevard Barat Raya...',
                          hintStyle: GoogleFonts.plusJakartaSans(color: Colors.white24),
                          filled: true,
                          fillColor: const Color(0xFF0A0A0A),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Address cannot be empty' : null,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setModalState(() => isAdding = false),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFD4AF37)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: const Color(0xFFD4AF37))),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (!addressFormKey.currentState!.validate()) return;
                                setState(() {
                                  _savedAddresses.add({
                                    'label': labelController.text.trim(),
                                    'address': addressController.text.trim(),
                                    'isPrimary': false,
                                  });
                                });
                                setModalState(() => isAdding = false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD4AF37),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text('Save Address', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saved Addresses',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFD4AF37),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFFD4AF37)),
                        onPressed: () => setModalState(() => isAdding = true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _savedAddresses.length,
                      itemBuilder: (context, index) {
                        final item = _savedAddresses[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A0A0A),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: item['isPrimary'] ? const Color(0xFFD4AF37).withOpacity(0.4) : Colors.white.withOpacity(0.03),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                item['label'].toString().toLowerCase() == 'home'
                                    ? Icons.home_rounded
                                    : Icons.work_rounded,
                                color: const Color(0xFFD4AF37),
                                size: 20,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          item['label'],
                                          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                        if (item['isPrimary']) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFD4AF37).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'Primary',
                                              style: GoogleFonts.plusJakartaSans(color: const Color(0xFFD4AF37), fontSize: 8, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['address'],
                                      style: GoogleFonts.plusJakartaSans(color: Colors.white54, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPaymentMethodsBottomSheet() {
    final TextEditingController numberController = TextEditingController();
    final TextEditingController expiryController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();
    final GlobalKey<FormState> cardFormKey = GlobalKey<FormState>();
    bool isAdding = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            if (isAdding) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: 24.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
                ),
                child: Form(
                  key: cardFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Add Credit / Debit Card',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFD4AF37),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Card Number',
                        style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: numberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
                        style: GoogleFonts.plusJakartaSans(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '4111 2222 3333 4444',
                          hintStyle: GoogleFonts.plusJakartaSans(color: Colors.white24),
                          filled: true,
                          fillColor: const Color(0xFF0A0A0A),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        validator: (v) => (v == null || v.trim().length < 16) ? 'Enter a valid 16-digit card number' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expiry Date',
                                  style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: expiryController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [LengthLimitingTextInputFormatter(5)],
                                  style: GoogleFonts.plusJakartaSans(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: '12/29',
                                    hintStyle: GoogleFonts.plusJakartaSans(color: Colors.white24),
                                    filled: true,
                                    fillColor: const Color(0xFF0A0A0A),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                  validator: (v) => (v == null || !v.contains('/')) ? 'Invalid' : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CVV',
                                  style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: cvvController,
                                  obscureText: true,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                                  style: GoogleFonts.plusJakartaSans(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: '•••',
                                    hintStyle: GoogleFonts.plusJakartaSans(color: Colors.white24),
                                    filled: true,
                                    fillColor: const Color(0xFF0A0A0A),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                  validator: (v) => (v == null || v.trim().length < 3) ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setModalState(() => isAdding = false),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFD4AF37)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: const Color(0xFFD4AF37))),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (!cardFormKey.currentState!.validate()) return;
                                final numStr = numberController.text;
                                final maskedNumber = '•••• •••• •••• ${numStr.substring(numStr.length - 4)}';
                                final cardType = numStr.startsWith('4') ? 'Visa' : 'MasterCard';
                                setState(() {
                                  _paymentCards.add({
                                    'type': cardType,
                                    'number': maskedNumber,
                                    'expiry': expiryController.text,
                                    'holder': _fullName,
                                  });
                                });
                                setModalState(() => isAdding = false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD4AF37),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text('Add Card', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Methods',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFD4AF37),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_card_rounded, color: Color(0xFFD4AF37)),
                        onPressed: () => setModalState(() => isAdding = true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _paymentCards.length,
                      itemBuilder: (context, index) {
                        final card = _paymentCards[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: card['type'] == 'Visa'
                                  ? [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]
                                  : [const Color(0xFF141414), const Color(0xFF2E2E2E)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.04)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    card['type'],
                                    style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                  ),
                                  const Icon(Icons.credit_card_rounded, color: Color(0xFFD4AF37), size: 24),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text(
                                card['number'],
                                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 18, letterSpacing: 2.0, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('CARD HOLDER', style: GoogleFonts.plusJakartaSans(color: Colors.white30, fontSize: 8)),
                                      const SizedBox(height: 2),
                                      Text(card['holder'], style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('EXPIRES', style: GoogleFonts.plusJakartaSans(color: Colors.white30, fontSize: 8)),
                                      const SizedBox(height: 2),
                                      Text(card['expiry'], style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSecuritySettingsBottomSheet() {
    final TextEditingController oldPassController = TextEditingController();
    final TextEditingController newPassController = TextEditingController();
    final TextEditingController confirmPassController = TextEditingController();
    final GlobalKey<FormState> passFormKey = GlobalKey<FormState>();
    bool isLoading = false;
    bool isSuccess = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            if (isSuccess) {
              return Container(
                padding: const EdgeInsets.all(32),
                height: 320,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Password Updated!',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your account password has been changed successfully.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              );
            }

            if (isLoading) {
              return SizedBox(
                height: 320,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37))),
                      const SizedBox(height: 24),
                      Text(
                        'Updating Password...',
                        style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              child: Form(
                key: passFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Security Settings',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFD4AF37),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Current Password', style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: oldPassController,
                      obscureText: true,
                      style: GoogleFonts.plusJakartaSans(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF0A0A0A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter current password' : null,
                    ),
                    const SizedBox(height: 16),
                    Text('New Password', style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: newPassController,
                      obscureText: true,
                      style: GoogleFonts.plusJakartaSans(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF0A0A0A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (v) => (v == null || v.trim().length < 6) ? 'Password must be at least 6 characters' : null,
                    ),
                    const SizedBox(height: 16),
                    Text('Confirm New Password', style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: confirmPassController,
                      obscureText: true,
                      style: GoogleFonts.plusJakartaSans(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF0A0A0A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Please confirm your new password';
                        if (v != newPassController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!passFormKey.currentState!.validate()) return;
                          setModalState(() => isLoading = true);
                          Future.delayed(const Duration(seconds: 2), () {
                            setModalState(() {
                              isLoading = false;
                              isSuccess = true;
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              if (!context.mounted) return;
                              if (Navigator.canPop(context)) Navigator.of(context).pop();
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Update Password', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _generateAIResponse(String prompt) {
    final cleanPrompt = prompt.toLowerCase();
    
    if (cleanPrompt.contains('halo') || cleanPrompt.contains('hai') || cleanPrompt.contains('pagi') || cleanPrompt.contains('siang') || cleanPrompt.contains('sore') || cleanPrompt.contains('malam')) {
      return 'Halo! Saya Admin Barber (AI Assistant). Ada yang bisa saya bantu mengenai pemesanan barbershop, KlikMart, KlikPay, atau info antrean Anda?';
    }
    
    if (cleanPrompt.contains('batal') || cleanPrompt.contains('cancel') || cleanPrompt.contains('refund') || cleanPrompt.contains('kembali')) {
      return 'Untuk membatalkan antrean, Anda cukup masuk ke menu Booking, lalu tekan tombol merah "Cancel Queue". Saldo KlikPay Anda akan otomatis dikembalikan 100% secara instan!';
    }
    
    if (cleanPrompt.contains('top up') || cleanPrompt.contains('topup') || cleanPrompt.contains('saldo') || cleanPrompt.contains('isi')) {
      return 'Anda bisa melakukan pengisian saldo secara instan dengan membuka menu Wallet, lalu tap tombol "Top Up". Pilih nominal (Rp 50rb - Rp 500rb) dan selesaikan dengan Bank Transfer atau KlikPay Instant.';
    }
    
    if (cleanPrompt.contains('bayar') || cleanPrompt.contains('transaksi') || cleanPrompt.contains('scan') || cleanPrompt.contains('qr')) {
      return 'KlikPay mendukung pembayaran non-tunai yang praktis! Anda bisa menggunakan fitur "Scan QR" di menu Wallet untuk membayar langsung di outlet kami dengan memindai kode QR kasir.';
    }
    
    if (cleanPrompt.contains('klikmart') || cleanPrompt.contains('beli') || cleanPrompt.contains('produk') || cleanPrompt.contains('clay') || cleanPrompt.contains('pomade') || cleanPrompt.contains('shampoo')) {
      return 'Semua produk perawatan rambut terbaik tersedia di menu Mart. Anda bisa berbelanja pomade premium, clay, dan shampoo. Pembayaran akan dipotong langsung dari saldo KlikPay Anda!';
    }
    
    if (cleanPrompt.contains('pesan') || cleanPrompt.contains('booking') || cleanPrompt.contains('potong') || cleanPrompt.contains('cukur') || cleanPrompt.contains('antre')) {
      return 'Untuk memesan layanan KlikCut, Anda bisa menekan tombol gunting melayang di kanan bawah layar Home, memilih outlet terdekat, menentukan barber favorit, serta waktu layanan yang diinginkan.';
    }
    
    if (cleanPrompt.contains('point') || cleanPrompt.contains('poin') || cleanPrompt.contains('xp') || cleanPrompt.contains('loyalty')) {
      return 'Poin loyalitas (XP Points) Anda dikumpulkan dari setiap transaksi potong rambut dan belanja di KlikMart. Kumpulkan terus XP untuk meningkatkan level keanggotaan Anda dan dapatkan diskon eksklusif!';
    }
    
    if (cleanPrompt.contains('alamat') || cleanPrompt.contains('lokasi') || cleanPrompt.contains('cabang') || cleanPrompt.contains('toko') || cleanPrompt.contains('outlet')) {
      return 'Outlet utama kami berlokasi di Jl. Senopati No. 12, Kebayoran Baru, Jakarta Selatan. Anda dapat melihat peta petunjuk arah secara interaktif dengan menekan tombol "View Directions" pada tiket antrean aktif Anda di menu Booking.';
    }

    if (cleanPrompt.contains('harga') || cleanPrompt.contains('tarif') || cleanPrompt.contains('biaya') || cleanPrompt.contains('ongkos')) {
      return 'Tarif layanan bervariasi: KlikCut Gentleman\'s Cut & Wash adalah Rp 85.000, Premium Shave adalah Rp 60.000, dan harga produk KlikMart berkisar antara Rp 50.000 hingga Rp 250.000.';
    }

    if (cleanPrompt.contains('terima kasih') || cleanPrompt.contains('makasih') || cleanPrompt.contains('thanks') || cleanPrompt.contains('oke')) {
      return 'Sama-sama! Senang bisa membantu Anda. Jika ada hal lain yang ingin ditanyakan seputar BARBERKLIK, saya siap menjawab.';
    }
    
    return 'Pertanyaan menarik! Sebagai AI Assistant BARBERKLIK, saya sarankan Anda memeriksa menu Home untuk promo terbaru, menu Wallet untuk cek saldo KlikPay, atau hubungi CS kami di +62 812-3456-7890 jika ada keadaan darurat.';
  }

  void _showHelpCenterBottomSheet() {
    bool isChatting = false;
    final List<Map<String, String>> chatMessages = [
      {'sender': 'agent', 'msg': 'Halo! Saya Admin Barber, asisten support BARBERKLIK Anda. Ada yang bisa saya bantu hari ini?'},
    ];
    final TextEditingController msgController = TextEditingController();
    bool agentIsTyping = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            if (isChatting) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 20.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37), size: 18),
                          onPressed: () => setModalState(() => isChatting = false),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFFD4AF37).withOpacity(0.2),
                          child: const Icon(Icons.support_agent_rounded, color: Color(0xFFD4AF37), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer Support', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            Text(agentIsTyping ? 'Admin Barber is typing...' : 'Online', style: GoogleFonts.plusJakartaSans(color: agentIsTyping ? const Color(0xFFD4AF37) : Colors.green, fontSize: 9, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white10, height: 24),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: chatMessages.length,
                        itemBuilder: (context, index) {
                          final chat = chatMessages[index];
                          final bool isMe = chat['sender'] == 'user';
                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMe ? const Color(0xFFD4AF37) : const Color(0xFF0A0A0A),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: Radius.circular(isMe ? 16 : 0),
                                  bottomRight: Radius.circular(isMe ? 0 : 16),
                                ),
                              ),
                              child: Text(
                                chat['msg']!,
                                style: GoogleFonts.plusJakartaSans(
                                  color: isMe ? Colors.black : Colors.white,
                                  fontSize: 12,
                                  fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: msgController,
                            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              hintStyle: GoogleFonts.plusJakartaSans(color: Colors.white30),
                              filled: true,
                              fillColor: const Color(0xFF0A0A0A),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            final userText = msgController.text.trim();
                            if (userText.isEmpty) return;
                            setModalState(() {
                              chatMessages.add({'sender': 'user', 'msg': userText});
                              msgController.clear();
                              agentIsTyping = true;
                            });

                            Future.delayed(const Duration(seconds: 2), () {
                              setModalState(() {
                                agentIsTyping = false;
                                final String reply = _generateAIResponse(userText);
                                chatMessages.add({'sender': 'agent', 'msg': reply});
                              });
                            });
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFFD4AF37),
                            child: Icon(Icons.send_rounded, color: Colors.black, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Help Center',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFD4AF37),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => setModalState(() => isChatting = true),
                        icon: const Icon(Icons.support_agent_rounded, size: 16),
                        label: Text('Live Chat', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('FREQUENTLY ASKED QUESTIONS', style: GoogleFonts.plusJakartaSans(color: const Color(0xFFD4AF37), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  const SizedBox(height: 12),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text('Bagaimana cara memesan KlikCut?', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text('Anda dapat memesan KlikCut dari beranda/home dengan mengetuk logo gunting di pojok kanan bawah atau memilih barbershop terdekat.', style: GoogleFonts.plusJakartaSans(color: Colors.white54, fontSize: 12)),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text('Berapa lama estimasi antrean?', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text('Estimasi antrean dihitung real-time berdasarkan jumlah orang di depan Anda dan jenis layanan yang mereka pilih.', style: GoogleFonts.plusJakartaSans(color: Colors.white54, fontSize: 12)),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text('Apakah uang kembali jika saya membatalkan pesanan?', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text('Ya, jika Anda membatalkan pesanan KlikCut Anda sebelum dilayani, dana saldo Anda akan dikembalikan 100% secara instan.', style: GoogleFonts.plusJakartaSans(color: Colors.white54, fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLogoutConfirmationBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Are you sure you want to logout?',
                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'You will need to sign in again to access BARBERKLIK grooming services.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(color: Colors.white38, fontSize: 12),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const SplashScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF08080),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Logout', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 1. Profile Header Widget
  Widget _buildProfileHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Menggunakan BoxDecoration untuk memberikan efek pendaran halus (glow) emas di sekitar lingkaran foto
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4AF37).withOpacity(0.25),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Elemen Dasar: CircleAvatar besar dengan radius 60
              ValueListenableBuilder<Uint8List?>(
                valueListenable: userProfileImageNotifier,
                builder: (context, imageBytes, child) {
                  return CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFFD4AF37), // Bingkai (border) tebal berwarna emas
                    child: CircleAvatar(
                      radius: 56, // Ukuran sedikit lebih kecil untuk memperlihatkan bingkai emas
                      backgroundColor: const Color(0xFF141414),
                      // Menampilkan foto: jika imageBytes null, gunakan placeholder NetworkImage. Jika ada, gunakan MemoryImage.
                      backgroundImage: imageBytes != null
                          ? MemoryImage(imageBytes)
                          : const NetworkImage(
                              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=250&q=80',
                            ) as ImageProvider,
                    ),
                  );
                },
              ),
              // Tombol Aksi di pojok kanan bawah
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImageFromGallery,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37), // Tombol berbentuk lingkaran emas kecil
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0A0A0A), // Pemisah gelap dengan foto utama
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt, // Ikon kamera hitam di tengah
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Nama pengguna: Alexander (diperbarui sesuai request)
        Text(
          _fullName,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // Badge: GOLD MEMBER tetap dipertahankan
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.4),
            ),
          ),
          child: Text(
            l10n.goldMember,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFD4AF37),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  // 2. Points Card Widget
  Widget _buildPointsCard() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF141414), // Dark grey
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.loyaltyPoints,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              Text(
                '2.450 pts',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFD4AF37), // Gold
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.65, // Simulated loyalty progression
              backgroundColor: Color(0xFF0A0A0A),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.pointsUntilNextReward,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white38,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFFD4AF37).withOpacity(0.8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // 3. List Tile Widget Item
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: const Color(0xFFD4AF37),
        ),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.white30,
        ),
      ),
    );
  }

  // 4. Logout Button Widget
  Widget _buildLogoutButton() {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: _showLogoutConfirmationBottomSheet,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFF08080), // Soft pink/red color
          side: BorderSide(color: const Color(0xFFF08080).withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          l10n.logout,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget Dropdown Bahasa khusus bertema Luxury Dark Mode
  Widget _buildLanguageMenuItem() {
    final l10n = AppLocalizations.of(context)!;
    final isIndonesian = appLocaleNotifier.value.languageCode == 'id';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.language_rounded,
          color: Color(0xFFD4AF37),
        ),
        title: Text(
          l10n.language,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: DropdownButton<String>(
          value: isIndonesian ? 'id' : 'en',
          dropdownColor: const Color(0xFF141414),
          underline: const SizedBox(),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54),
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFFD4AF37),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          onChanged: (String? newLanguage) {
            if (newLanguage != null) {
              setState(() {
                appLocaleNotifier.value = Locale(newLanguage);
              });
            }
          },
          items: const [
            DropdownMenuItem(
              value: 'en',
              child: Text('English'),
            ),
            DropdownMenuItem(
              value: 'id',
              child: Text('Indonesia'),
            ),
          ],
        ),
      ),
    );
  }

  // 5. Navigation Bar Widget
  Widget _buildBottomNavigationBar() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, l10n.home, 0),
          _buildNavItem(Icons.storefront_outlined, l10n.mart, 1),
          _buildNavItem(Icons.calendar_month_outlined, l10n.booking, 2),
          _buildNavItem(Icons.account_balance_wallet_outlined, l10n.wallet, 3),
          _buildNavItem(Icons.person_rounded, l10n.profile, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = index == 4; // Profile is active
    return InkWell(
      onTap: () {
        if (index == 0) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (index == 1) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const KlikMartScreen()),
          );
        } else if (index == 2) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const QueueStatusScreen()),
          );
        } else if (index == 3) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WalletScreen()),
          );
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFFD4AF37) : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: isActive ? const Color(0xFFD4AF37) : Colors.grey,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
