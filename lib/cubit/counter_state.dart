part of 'counter_cubit.dart';

@override
abstract class CounterState {}

class CounterInitial extends CounterState {
  final int value;
  CounterInitial({required this.value,});
}

class CounterIncrement extends CounterState {
  final int value;
  CounterIncrement({ required this.value, });
}

