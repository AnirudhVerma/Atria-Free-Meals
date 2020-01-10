import 'dart:async';
import 'package:bloc/bloc.dart';
import '../bloc.dart';

class BookServiceBloc extends Bloc<BookServiceEvent, BookServiceState> {
  @override
  BookServiceState get initialState => InitialBookServiceState();

  @override
  Stream<BookServiceState> mapEventToState(
    BookServiceEvent event,
  ) async* {
    if (event is FetchBankList){
      yield BankListState();
    }
    if (event is RegisteredNumber){
      yield EnterRegisteredNumberState();
    }
    if (event is EnterBankOTP){
      yield EnterBankOTPState();
    }
    if (event is FetchAccountList){
      yield AccountListState();
    }
    if (event is FetchBranchList){
      yield BranchListState();
    }
    if (event is FetchTimeSlot){
      yield TimeSlotState();
    }
    // TODO: Add Logic
  }
}
