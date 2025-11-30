// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BookStore on _BookStore, Store {
  late final _$packageInfoAtom =
      Atom(name: '_BookStore.packageInfo', context: context);

  @override
  PackageInfo? get packageInfo {
    _$packageInfoAtom.reportRead();
    return super.packageInfo;
  }

  @override
  set packageInfo(PackageInfo? value) {
    _$packageInfoAtom.reportWrite(value, super.packageInfo, () {
      super.packageInfo = value;
    });
  }

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

  late final _$searchResultsAtom =
      Atom(name: '_BookStore.searchResults', context: context);

  @override
  ObservableList<Book> get searchResults {
    _$searchResultsAtom.reportRead();
    return super.searchResults;
  }

  @override
  set searchResults(ObservableList<Book> value) {
    _$searchResultsAtom.reportWrite(value, super.searchResults, () {
      super.searchResults = value;
    });
  }

  late final _$favoritesAtom =
      Atom(name: '_BookStore.favorites', context: context);

  @override
  ObservableList<Book> get favorites {
    _$favoritesAtom.reportRead();
    return super.favorites;
  }

  @override
  set favorites(ObservableList<Book> value) {
    _$favoritesAtom.reportWrite(value, super.favorites, () {
      super.favorites = value;
    });
  }

  late final _$bookmarksAtom =
      Atom(name: '_BookStore.bookmarks', context: context);

  @override
  ObservableList<Book> get bookmarks {
    _$bookmarksAtom.reportRead();
    return super.bookmarks;
  }

  @override
  set bookmarks(ObservableList<Book> value) {
    _$bookmarksAtom.reportWrite(value, super.bookmarks, () {
      super.bookmarks = value;
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

  late final _$isSearchingAtom =
      Atom(name: '_BookStore.isSearching', context: context);

  @override
  bool get isSearching {
    _$isSearchingAtom.reportRead();
    return super.isSearching;
  }

  @override
  set isSearching(bool value) {
    _$isSearchingAtom.reportWrite(value, super.isSearching, () {
      super.isSearching = value;
    });
  }

  late final _$myLibraryAtom =
      Atom(name: '_BookStore.myLibrary', context: context);

  @override
  ObservableList<Book> get myLibrary {
    _$myLibraryAtom.reportRead();
    return super.myLibrary;
  }

  @override
  set myLibrary(ObservableList<Book> value) {
    _$myLibraryAtom.reportWrite(value, super.myLibrary, () {
      super.myLibrary = value;
    });
  }

  late final _$lastReadBookIdAtom =
      Atom(name: '_BookStore.lastReadBookId', context: context);

  @override
  String? get lastReadBookId {
    _$lastReadBookIdAtom.reportRead();
    return super.lastReadBookId;
  }

  @override
  set lastReadBookId(String? value) {
    _$lastReadBookIdAtom.reportWrite(value, super.lastReadBookId, () {
      super.lastReadBookId = value;
    });
  }

  late final _$currentExploreSortAtom =
      Atom(name: '_BookStore.currentExploreSort', context: context);

  @override
  BookSortOption get currentExploreSort {
    _$currentExploreSortAtom.reportRead();
    return super.currentExploreSort;
  }

  @override
  set currentExploreSort(BookSortOption value) {
    _$currentExploreSortAtom.reportWrite(value, super.currentExploreSort, () {
      super.currentExploreSort = value;
    });
  }

  late final _$publicDomainBooksAtom =
      Atom(name: '_BookStore.publicDomainBooks', context: context);

  @override
  ObservableList<Book> get publicDomainBooks {
    _$publicDomainBooksAtom.reportRead();
    return super.publicDomainBooks;
  }

  @override
  set publicDomainBooks(ObservableList<Book> value) {
    _$publicDomainBooksAtom.reportWrite(value, super.publicDomainBooks, () {
      super.publicDomainBooks = value;
    });
  }

  late final _$fetchGutendexBooksAsyncAction =
      AsyncAction('_BookStore.fetchGutendexBooks', context: context);

  @override
  Future<void> fetchGutendexBooks({String? searchQuery}) {
    return _$fetchGutendexBooksAsyncAction
        .run(() => super.fetchGutendexBooks(searchQuery: searchQuery));
  }

  late final _$importExternalBookAsyncAction =
      AsyncAction('_BookStore.importExternalBook', context: context);

  @override
  Future<void> importExternalBook(Book book) {
    return _$importExternalBookAsyncAction
        .run(() => super.importExternalBook(book));
  }

  late final _$fetchHomeScreenDataAsyncAction =
      AsyncAction('_BookStore.fetchHomeScreenData', context: context);

  @override
  Future<void> fetchHomeScreenData() {
    return _$fetchHomeScreenDataAsyncAction
        .run(() => super.fetchHomeScreenData());
  }

  late final _$searchBooksAsyncAction =
      AsyncAction('_BookStore.searchBooks', context: context);

  @override
  Future<void> searchBooks(String query,
      {BookSortOption sort = BookSortOption.relevance}) {
    return _$searchBooksAsyncAction
        .run(() => super.searchBooks(query, sort: sort));
  }

  late final _$addToLibraryAsyncAction =
      AsyncAction('_BookStore.addToLibrary', context: context);

  @override
  Future<void> addToLibrary(Book book) {
    return _$addToLibraryAsyncAction.run(() => super.addToLibrary(book));
  }

  late final _$fetchUserLibraryAsyncAction =
      AsyncAction('_BookStore.fetchUserLibrary', context: context);

  @override
  Future<void> fetchUserLibrary() {
    return _$fetchUserLibraryAsyncAction.run(() => super.fetchUserLibrary());
  }

  late final _$openBookAsyncAction =
      AsyncAction('_BookStore.openBook', context: context);

  @override
  Future<Uint8List> openBook(Book book) {
    return _$openBookAsyncAction.run(() => super.openBook(book));
  }

  late final _$resumeReadingAsyncAction =
      AsyncAction('_BookStore.resumeReading', context: context);

  @override
  Future<Uint8List> resumeReading() {
    return _$resumeReadingAsyncAction.run(() => super.resumeReading());
  }

  late final _$fetchUserDataAsyncAction =
      AsyncAction('_BookStore.fetchUserData', context: context);

  @override
  Future<void> fetchUserData() {
    return _$fetchUserDataAsyncAction.run(() => super.fetchUserData());
  }

  late final _$toggleFavoriteAsyncAction =
      AsyncAction('_BookStore.toggleFavorite', context: context);

  @override
  Future<void> toggleFavorite(Book book) {
    return _$toggleFavoriteAsyncAction.run(() => super.toggleFavorite(book));
  }

  late final _$toggleBookmarkAsyncAction =
      AsyncAction('_BookStore.toggleBookmark', context: context);

  @override
  Future<void> toggleBookmark(Book book) {
    return _$toggleBookmarkAsyncAction.run(() => super.toggleBookmark(book));
  }

  late final _$_BookStoreActionController =
      ActionController(name: '_BookStore', context: context);

  @override
  void setExploreSort(BookSortOption option) {
    final _$actionInfo = _$_BookStoreActionController.startAction(
        name: '_BookStore.setExploreSort');
    try {
      return super.setExploreSort(option);
    } finally {
      _$_BookStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void searchBooksDebounced(String query) {
    final _$actionInfo = _$_BookStoreActionController.startAction(
        name: '_BookStore.searchBooksDebounced');
    try {
      return super.searchBooksDebounced(query);
    } finally {
      _$_BookStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSearch() {
    final _$actionInfo = _$_BookStoreActionController.startAction(
        name: '_BookStore.clearSearch');
    try {
      return super.clearSearch();
    } finally {
      _$_BookStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
packageInfo: ${packageInfo},
carousels: ${carousels},
searchResults: ${searchResults},
favorites: ${favorites},
bookmarks: ${bookmarks},
isLoading: ${isLoading},
isSearching: ${isSearching},
myLibrary: ${myLibrary},
lastReadBookId: ${lastReadBookId},
currentExploreSort: ${currentExploreSort},
publicDomainBooks: ${publicDomainBooks}
    ''';
  }
}
