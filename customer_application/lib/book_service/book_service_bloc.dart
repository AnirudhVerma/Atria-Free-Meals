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
    if (event is AddressEvent){
      yield InitialBookServiceState();
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
    if (event is FetchLiamAccount){
      yield LiamAccountListState();
    }
    if (event is BookingResult){
      yield BookingResultState();
    }
    if (event is ShowProgressIndicator){
      yield ProgressIndicatorState();
    }
    // TODO: Add Logic
  }
}
