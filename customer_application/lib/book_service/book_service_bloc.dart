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
    // TODO: Add Logic
  }
}
