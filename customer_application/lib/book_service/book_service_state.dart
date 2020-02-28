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

class EnterBankOTPState extends BookServiceState {
  @override
  List<Object> get props => [];
}

class AccountListState extends BookServiceState {
  @override
  List<Object> get props => [];
}

class BranchListState extends BookServiceState {
  @override
  List<Object> get props => [];
}

class TimeSlotState extends BookServiceState {
  @override
  List<Object> get props => [];
}

class LiamAccountListState extends BookServiceState {
  @override
  List<Object> get props => [];
}

class BookingResultState extends BookServiceState {
  @override
  List<Object> get props => [];
}
