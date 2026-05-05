
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../../data/Cubits/AuthCubit/auth_cubit.dart';

class BlocProviders {
  static final List<SingleChildWidget> providers = [
    BlocProvider<AuthCubit>(create: (_)=>AuthCubit()),

  ];
}