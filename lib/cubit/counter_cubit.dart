
import 'package:flutter_bloc/flutter_bloc.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  int value;
  CounterCubit(this.value) : super(CounterInitial(value: value));

  void incrementCounter(){
    emit(CounterIncrement(value: ++value));
  }
}
