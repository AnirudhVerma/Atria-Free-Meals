import 'package:equatable/equatable.dart';

abstract class BookServiceNewState {
  const BookServiceNewState();
}

class InitialBookServiceNewState extends BookServiceNewState {
  @override
  List<Object> get props => [];
}


class AccountState extends BookServiceNewState {
  @override
  List<Object> get props => [];
}