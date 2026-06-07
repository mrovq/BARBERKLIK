import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import 'home_screen.dart';
import 'klikmart_screen.dart';
import 'queue_status_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Menggunakan Uint8List untuk menyimpan bytes foto agar kompatibel dengan Flutter Web dan Mobile (menghindari error Unsupported operation: _Namespace)
  Uint8List? _imageBytes;

  /// Fungsi asynchronous untuk mengambil foto dari galeri menggunakan package image_picker.
  /// Setelah foto berhasil dipilih, bytes gambar akan dibaca dan state _imageBytes akan diperbarui.
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
        setState(() {
          _imageBytes = bytes;
        });
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
            onPressed: () {},
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
            _buildMenuItem(Icons.account_balance_wallet_outlined, l10n.myWallet, () {}),
            _buildMenuItem(Icons.history_rounded, l10n.bookingHistory, () {}),
            _buildMenuItem(Icons.location_on_outlined, l10n.savedAddresses, () {}),
            _buildMenuItem(Icons.credit_card_rounded, l10n.paymentMethods, () {}),
            
            // Dropdown Pilihan Bahasa bertema Luxury Dark Mode
            _buildLanguageMenuItem(),
            
            const SizedBox(height: 24),
            _buildSectionHeader(l10n.securityAndSupport),
            const SizedBox(height: 10),
            _buildMenuItem(Icons.security_rounded, l10n.securitySettings, () {}),
            _buildMenuItem(Icons.help_outline_rounded, l10n.helpCenter, () {}),
            const SizedBox(height: 32),
            _buildLogoutButton(),
            const SizedBox(height: 120), // Padding above bottom navigation bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
              CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFFD4AF37), // Bingkai (border) tebal berwarna emas
                child: CircleAvatar(
                  radius: 56, // Ukuran sedikit lebih kecil untuk memperlihatkan bingkai emas
                  backgroundColor: const Color(0xFF141414),
                  // Menampilkan foto: jika _imageBytes null, gunakan placeholder NetworkImage. Jika ada, gunakan MemoryImage.
                  backgroundImage: _imageBytes != null
                      ? MemoryImage(_imageBytes!)
                      : const NetworkImage(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=250&q=80',
                        ) as ImageProvider,
                ),
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
          'Alexander',
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
        onPressed: () {},
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
