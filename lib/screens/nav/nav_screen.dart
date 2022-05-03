import 'package:flutter/material.dart';
import 'package:instagram_bloc/enums/bottom_nav_item.dart';
import 'package:instagram_bloc/screens/nav/widgets/widgets.dart';

class NavScreen extends StatelessWidget {
  const NavScreen({Key? key}) : super(key: key);
   static const String routeName = '/nav';
  static Route route(){
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => NavScreen(),
    );
  }

  final Map<BottomNavItem, IconData> items = const {
    BottomNavItem.feed: Icons.home,
    BottomNavItem.search: Icons.search,
    BottomNavItem.create: Icons.add,
    BottomNavItem.notifications: Icons.favorite_border,
    BottomNavItem.profile: Icons.account_circle,
  };
  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async => false,
      child: Scaffold(
        body: Center(
          child: Text('NAVVVVVV'),
          ),
        bottomNavigationBar: BottomNavBar(
          onTap: (int ) { print(int); },
          items: items,
          selectedItem: BottomNavItem.feed,
          ),
      ),
    );
  }
}