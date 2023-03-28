import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SearchBarState {}
class SearchValidated extends SearchBarState{
  String searchString;
  SearchValidated(this.searchString);
}
class SearchFail extends SearchBarState{}

abstract class SearchBarEvent{}
class TestSearchEvent extends SearchBarEvent{
  final String searchString;
  TestSearchEvent(this.searchString);
}


class SearchBarBloc extends Bloc<SearchBarEvent, SearchBarState> {
  SearchBarBloc() : super(_getInitState()) {
    on<TestSearchEvent>(_onTestSearch);
  }
  static SearchBarState _getInitState() {
    final state = SearchFail();
    return state;
  }
}

Future<void> _onTestSearch(event, emit) async {
  String searchStringTest = (event as TestSearchEvent).searchString;
  if(searchStringTest.isNotEmpty){
    final state = SearchValidated(searchStringTest);
    emit(state);
  }
  else{
    final state = SearchFail();
    emit(state);
  }
}
