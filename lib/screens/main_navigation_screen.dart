import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';
import 'catalogue_screen.dart';
import 'home_screen.dart';
import 'sdg_dashboard_screen.dart';
import 'wishlist_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onTabChange: _onTabTapped),
      const CatalogueScreen(),
      WishlistScreen(onExplore: () => _onTabTapped(1)),
      CartScreen(onExplore: () => _onTabTapped(1)),
      const SdgDashboardScreen(),
    ];

    return Consumer2<WishlistProvider, CartProvider>(
      builder: (context, wishlist, cart, _) {
        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 16,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onTabTapped,
              backgroundColor: Colors.white,
              indicatorColor: AppTheme.primary.withAlpha(25),
              elevation: 0,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded, color: AppTheme.primary),
                  label: 'Home',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view_rounded, color: AppTheme.primary),
                  label: 'Catalogue',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: wishlist.itemCount > 0,
                    label: Text('${wishlist.itemCount}'),
                    child: const Icon(Icons.favorite_outline_rounded),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: wishlist.itemCount > 0,
                    label: Text('${wishlist.itemCount}'),
                    child: const Icon(Icons.favorite_rounded, color: AppTheme.primary),
                  ),
                  label: 'Wishlist',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: cart.itemCount > 0,
                    backgroundColor: AppTheme.terracotta,
                    label: Text('${cart.itemCount}'),
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: cart.itemCount > 0,
                    backgroundColor: AppTheme.terracotta,
                    label: Text('${cart.itemCount}'),
                    child: const Icon(Icons.shopping_bag_rounded, color: AppTheme.primary),
                  ),
                  label: 'Cart',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.eco_outlined),
                  selectedIcon: Icon(Icons.eco_rounded, color: Color(0xFF2E7D32)),
                  label: 'SDG Impact',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
