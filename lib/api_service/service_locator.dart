import 'package:get_it/get_it.dart';
import 'package:tlbilling/view/sales/sales_view_bloc.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  static void setupLocator() {
    getIt.registerLazySingleton<SalesViewBlocImpl>(() => SalesViewBlocImpl());
  }
}
