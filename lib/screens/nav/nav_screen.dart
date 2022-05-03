import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc/enums/bottom_nav_item.dart';
import 'package:instagram_bloc/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:instagram_bloc/screens/nav/widgets/widgets.dart';

class NavScreen extends StatelessWidget {
  const NavScreen({Key? key}) : super(key: key);
  static const String routeName = '/nav';
  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
        create: (context) => BottomNavBarCubit(),
        child: const NavScreen(),
      ),
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
      onWillPop: () async => false,
      child: BlocConsumer<BottomNavBarCubit, BottomNavBarState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            body: const Center(
              child: Text('NAVVVVVV Screen'),
            ),
            bottomNavigationBar: BottomNavBar(
              items: items,
              selectedItem: state.selectedItem,
              onTap: (index) {
                final selectedItem = BottomNavItem.values[index];
                context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
              },
            ),
          );
        },
      ),
    );
  }
}
