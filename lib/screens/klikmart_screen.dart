import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';
import 'queue_status_screen.dart';
import 'profile_screen.dart';

class KlikMartScreen extends StatefulWidget {
  const KlikMartScreen({super.key});

  @override
  State<KlikMartScreen> createState() => _KlikMartScreenState();
}

class _KlikMartScreenState extends State<KlikMartScreen> {
  String _selectedCategory = 'All Products';
  final List<String> _categories = ['All Products', 'Pomade', 'Shampoo', 'Tools', 'Care'];

  // Categories list
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Premium Clay',
      'subtitle': 'Strong Hold • Matte',
      'rating': '4.9',
      'price': '\$24.00',
      'image': 'https://images.unsplash.com/photo-1608248597279-f99d160bfcbc?auto=format&fit=crop&w=300&q=80',
      'isFavorite': false,
    },
    {
      'name': 'Volume Shampoo',
      'subtitle': '250ml • Caffeine',
      'rating': '4.8',
      'price': '\$18.50',
      'image': 'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?auto=format&fit=crop&w=300&q=80',
      'isFavorite': true,
    },
    {
      'name': 'Gold Plated Comb',
      'subtitle': 'Signature Tool',
      'rating': '5.0',
      'price': '\$42.00',
      'image': 'https://images.unsplash.com/photo-1590156546746-c58d04f21626?auto=format&fit=crop&w=300&q=80',
      'isFavorite': false,
    },
    {
      'name': 'Artisan Beard Oil',
      'subtitle': 'Cedar & Sandalwood',
      'rating': '4.7',
      'price': '\$15.00',
      'image': 'https://images.unsplash.com/photo-1626015276681-285a6a42a27b?auto=format&fit=crop&w=300&q=80',
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Solid black background #0A0A0A
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80',
            ),
          ),
        ),
        title: Text(
          'BARBERKLIK',
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
              Icons.notifications_none_rounded,
              color: Color(0xFFD4AF37),
              size: 24,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildPromotionSlider(),
              const SizedBox(height: 24),
              _buildCategoriesSection(),
              const SizedBox(height: 24),
              _buildEssentialsSection(),
              const SizedBox(height: 100), // Scroll padding above navigation bar
            ],
          ),
        ),
      ),
      floatingActionButton: _buildCartFAB(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // 2. Banner Promosi Carousel
  Widget _buildPromotionSlider() {
    final List<Map<String, String>> banners = [
      {
        'title': 'FLASH SALE',
        'subtitle': 'Up to 40% Off Select Tools',
        'image': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&w=600&q=80',
      },
      {
        'title': 'NEW ARRIVAL',
        'subtitle': 'Premium Pomades are back in stock',
        'image': 'https://images.unsplash.com/photo-1593702275687-f8b402bf1fb5?auto=format&fit=crop&w=600&q=80',
      },
    ];

    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.88),
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(banner['image']!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.65), // Dramatic dark overlay
                  BlendMode.darken,
                ),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    banner['title']!,
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFD4AF37),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  banner['subtitle']!,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 3. Kategori Produk
  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.categories,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.viewAll,
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFD4AF37),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final bool isSelected = category == _selectedCategory;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.08),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: GoogleFonts.plusJakartaSans(
                        color: isSelected ? Colors.black : Colors.white70,
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 4. Grid Produk (KlikMart Essentials)
  Widget _buildEssentialsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.klikmartEssentials,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.filter_list_rounded,
                  color: Colors.white70,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final product = _products[index];
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.03)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with favorite button overlay
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              image: DecorationImage(
                                image: NetworkImage(product['image']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  product['isFavorite'] = !product['isFavorite'];
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  product['isFavorite']
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_outline_rounded,
                                  color: product['isFavorite'] ? Colors.red : Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Product Details
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rating
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFD4AF37),
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product['rating']!,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Name
                          Text(
                            product['name']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Subtitle
                          Text(
                            product['subtitle']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Price & Add button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product['price']!,
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFFD4AF37),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: const Color(0xFFD4AF37).withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Color(0xFFD4AF37),
                                  size: 14,
                                ),
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
          ),
        ],
      ),
    );
  }

  // 5. FAB with Shopping Cart and Badge
  Widget _buildCartFAB() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFD4AF37),
          foregroundColor: const Color(0xFF0A0A0A),
          shape: const CircleBorder(),
          elevation: 6,
          child: const Icon(
            Icons.shopping_cart_outlined,
            size: 24,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0A0A0A), width: 1.5),
            ),
            child: Text(
              '3',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 6. Bottom Navigation Bar Widget
  Widget _buildBottomNavigationBar() {
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
          _buildNavItem(Icons.home_outlined, AppLocalizations.of(context)!.home, 0),
          _buildNavItem(Icons.storefront_rounded, AppLocalizations.of(context)!.mart, 1),
          _buildNavItem(Icons.calendar_month_outlined, AppLocalizations.of(context)!.booking, 2),
          _buildNavItem(Icons.account_balance_wallet_outlined, AppLocalizations.of(context)!.wallet, 3),
          _buildNavItem(Icons.person_outline_rounded, AppLocalizations.of(context)!.profile, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = index == 1; // Mart is active
    return InkWell(
      onTap: () {
        if (index == 0) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (index == 2) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const QueueStatusScreen()),
          );
        } else if (index == 4) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
