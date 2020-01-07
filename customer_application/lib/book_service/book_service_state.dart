import 'package:equatable/equatable.dart';

abstract class BookServiceState extends Equatable {
   BookServiceState();
}

class InitialBookServiceState extends BookServiceState {
  @override
  List<Object> get props => [];
}

class BankListState extends BookServiceState {
  @override
  List<Object> get props => [];
}

class EnterRegisteredNumberState extends BookServiceState {
  @override
  List<Object> get props => [];
}