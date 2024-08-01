// ignore_for_file: avoid_print

import 'package:bloc_demo/test.dart';
import 'package:bloc_demo/test1.dart';
import 'package:bloc_demo/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  runApp(const App());
}

/// 自定义 Bloc观察者
/// 继承至 [BlocObserver]
/// [onChange]     Bloc状态改变时触发
/// [onTransition] Bloc状态转换时触发
class AppBlocObserver extends BlocObserver {
  /// {@macro app_bloc_observer}
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

/// 主题颜色
/// 观察器 [ThemeCubit]
/// 切换主题时会自动触发
class App extends StatelessWidget {
  /// {@macro app}
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: const AppView(),
    );
  }
}

/// App的页面
/// [BlocBuilder]<type?,type?>
/// type1：监听的 Cubit class类型
/// type2：监听的 Cubit<type1>
class AppView extends StatelessWidget {
  /// {@macro app_view}
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (_, theme) {
        return MaterialApp(
          theme: theme,
          home: const CounterPage(),
        );
      },
    );
  }
}

/// 主页
/// Bloc [CounterBloc] 监听
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    print("build");
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        backgroundColor: myColors.brandColor,
      ),
      body: Center(
        child: BlocBuilder<CounterBloc, int>(
          builder: (context, count) {
            return BlocProvider(
              create: (_) => ColorBloc(),
              child: BlocBuilder<ColorBloc, Color>(
                builder: (BuildContext context, state) {
                  return GestureDetector(
                    onTap: () => context.read<ColorBloc>().toggleColor(),
                    child: Text(
                      '$count',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: state),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "1",
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyWidget()));
            },
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            heroTag: "2",
            child: const Icon(Icons.remove),
            onPressed: () {
              context.read<CounterBloc>().add(CounterDecrementPressed());
            },
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            heroTag: "3",
            child: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}

/// Event being processed by [CounterBloc].
abstract class CounterEvent {}

/// Notifies bloc to increment state.
class CounterIncrementPressed extends CounterEvent {}

/// Notifies bloc to decrement state.
class CounterDecrementPressed extends CounterEvent {}

/// {@template counter_bloc}
/// A simple [Bloc] that manages an `int` as its state.
/// {@endtemplate}
class CounterBloc extends Bloc<CounterEvent, int> {
  /// {@macro counter_bloc}
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
    on<CounterDecrementPressed>((event, emit) => emit(state - 1));
  }
}

/// {@template brightness_cubit}
/// A simple [Cubit] that manages the [ThemeData] as its state.
/// {@endtemplate}
class ThemeCubit extends Cubit<ThemeData> {
  /// {@macro brightness_cubit}
  ThemeCubit() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    brightness: Brightness.dark,
    extensions: const <ThemeExtension<dynamic>>[
      MyColors(
        brandColor: Color(0xFF1E88E5),
        danger: Color(0xFFE53935),
      ),
    ],
  );

  static final _darkTheme = ThemeData(
    brightness: Brightness.light,
    extensions: const <ThemeExtension<dynamic>>[
      MyColors(
        brandColor: Color.fromARGB(255, 238, 17, 127),
        danger: Color.fromARGB(255, 42, 172, 122),
      ),
    ],
  );

  /// Toggles the current brightness between light and dark.
  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _darkTheme : _lightTheme);
  }
}

/// Color Bloc
/// 观察器 [ColorBloc]
/// 切换颜色时会自动触发
class ColorBloc extends Cubit<Color> {
  ColorBloc() : super(_red);

  static const _red = Colors.red;

  static const _green = Colors.green;

  void toggleColor() {
    emit(state == _red ? _green : _red);
  }
}
