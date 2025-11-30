// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'write_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WriteStore on _WriteStore, Store {
  late final _$draftsAtom = Atom(name: '_WriteStore.drafts', context: context);

  @override
  ObservableList<Map<String, dynamic>> get drafts {
    _$draftsAtom.reportRead();
    return super.drafts;
  }

  @override
  set drafts(ObservableList<Map<String, dynamic>> value) {
    _$draftsAtom.reportWrite(value, super.drafts, () {
      super.drafts = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_WriteStore.isLoading', context: context);

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

  late final _$saveStatusAtom =
      Atom(name: '_WriteStore.saveStatus', context: context);

  @override
  String get saveStatus {
    _$saveStatusAtom.reportRead();
    return super.saveStatus;
  }

  @override
  set saveStatus(String value) {
    _$saveStatusAtom.reportWrite(value, super.saveStatus, () {
      super.saveStatus = value;
    });
  }

  late final _$fetchDraftsAsyncAction =
      AsyncAction('_WriteStore.fetchDrafts', context: context);

  @override
  Future<void> fetchDrafts() {
    return _$fetchDraftsAsyncAction.run(() => super.fetchDrafts());
  }

  late final _$saveNowAsyncAction =
      AsyncAction('_WriteStore.saveNow', context: context);

  @override
  Future<void> saveNow() {
    return _$saveNowAsyncAction.run(() => super.saveNow());
  }

  late final _$_WriteStoreActionController =
      ActionController(name: '_WriteStore', context: context);

  @override
  void openDraft(Map<String, dynamic>? draft) {
    final _$actionInfo = _$_WriteStoreActionController.startAction(
        name: '_WriteStore.openDraft');
    try {
      return super.openDraft(draft);
    } finally {
      _$_WriteStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onTextChanged() {
    final _$actionInfo = _$_WriteStoreActionController.startAction(
        name: '_WriteStore.onTextChanged');
    try {
      return super.onTextChanged();
    } finally {
      _$_WriteStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
drafts: ${drafts},
isLoading: ${isLoading},
saveStatus: ${saveStatus}
    ''';
  }
}
