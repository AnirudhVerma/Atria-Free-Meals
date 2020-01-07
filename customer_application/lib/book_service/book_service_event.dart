import 'package:equatable/equatable.dart';

abstract class BookServiceEvent extends Equatable {
   BookServiceEvent();
}

class FetchBankList extends BookServiceEvent{
   @override
   List<Object> get props => null;
}

class RegisteredNumber extends BookServiceEvent{
   @override
   List<Object> get props => null;
}