import 'package:get_it/get_it.dart';
import 'package:tramatec_app/stores/book_store.dart';
import 'package:tramatec_app/stores/write_store.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingletonAsync<BookStore>(() async {
    final bookStore = BookStore();
    return bookStore;
  });
  getIt.registerSingleton<WriteStore>(WriteStore());

  await getIt.allReady();
}
