import 'package:equatable/equatable.dart';

abstract class BookServiceEvent extends Equatable {
   BookServiceEvent();
}

class AddressEvent extends BookServiceEvent{
   @override
   List<Object> get props => null;
}

class FetchBankList extends BookServiceEvent{
   @override
   List<Object> get props => null;
}

class RegisteredNumber extends BookServiceEvent{
   @override
   List<Object> get props => null;
}

class EnterBankOTP extends BookServiceEvent{
   @override
   List<Object> get props => null;
}

class FetchAccountList extends BookServiceEvent{
   @override
   List<Object> get props => null;
}

class FetchBranchList extends BookServiceEvent{
   @override
   List<Object> get props => null;
}

class FetchTimeSlot extends BookServiceEvent{
   @override
   List<Object> get props => null;
}

class FetchLiamAccount extends BookServiceEvent{
   @override
   List<Object> get props => null;
}