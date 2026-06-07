import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/helpers/cache_helper.dart';
import '../data/cubits/home/home_cubit.dart';
import '../data/cubits/language/language_cubit.dart';
import '../data/cubits/main/main_cubit.dart';
import '../features/home/data/repos/home_repo.dart';

/// App-wide cubits, available to the whole widget tree.
/// Dependencies are read from the [RepositoryProvider]s declared in `main.dart`.
class BlocProviders {
  static List<BlocProvider> get providers => [
        BlocProvider<LanguageCubit>(
          create: (context) => LanguageCubit(context.read<CacheHelper>()),
        ),
        BlocProvider<MainCubit>(
          create: (_) => MainCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(context.read<HomeRepo>())..init(),
        ),
      ];
}
