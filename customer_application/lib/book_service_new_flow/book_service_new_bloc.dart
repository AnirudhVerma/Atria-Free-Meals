import 'dart:async';
import 'package:bloc/bloc.dart';
import '../bloc.dart';

class BookServiceNewBloc extends Bloc<BookServiceNewEvent, BookServiceNewState> {
  @override
  BookServiceNewState get initialState => InitialBookServiceNewState();

  @override
  Stream<BookServiceNewState> mapEventToState(
    BookServiceNewEvent event,
  ) async* {
    if(event is AccountEvent){
      yield AccountState();
    }
  }
}
