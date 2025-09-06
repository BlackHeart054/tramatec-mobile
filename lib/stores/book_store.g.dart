// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BookStore on _BookStore, Store {
  late final _$carouselsAtom =
      Atom(name: '_BookStore.carousels', context: context);

  @override
  ObservableList<Carousel> get carousels {
    _$carouselsAtom.reportRead();
    return super.carousels;
  }

  @override
  set carousels(ObservableList<Carousel> value) {
    _$carouselsAtom.reportWrite(value, super.carousels, () {
      super.carousels = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_BookStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$fetchHomeScreenDataAsyncAction =
      AsyncAction('_BookStore.fetchHomeScreenData', context: context);

  @override
  Future<void> fetchHomeScreenData() {
    return _$fetchHomeScreenDataAsyncAction
        .run(() => super.fetchHomeScreenData());
  }

  @override
  String toString() {
    return '''
carousels: ${carousels},
isLoading: ${isLoading}
    ''';
  }
}
