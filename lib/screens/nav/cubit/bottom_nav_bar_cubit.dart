import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_bloc/enums/bottom_nav_item.dart';
import 'package:instagram_bloc/screens/nav/widgets/widgets.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(const BottomNavBarState(selectedItem: BottomNavItem.feed));

  void updateSelectedItem(BottomNavItem item){
      if(item != state.selectedItem){
        emit(BottomNavBarState(selectedItem: item));
      }
  }
}
