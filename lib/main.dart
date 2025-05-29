import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:h8_fli_geo_maps_starter/domain/repositories/firebase_repository.dart';
import 'package:h8_fli_geo_maps_starter/firebase_options.dart';
import 'package:h8_fli_geo_maps_starter/manager/geo_bloc.dart';
import 'package:h8_fli_geo_maps_starter/manager/history_bloc.dart';
import 'package:h8_fli_geo_maps_starter/service/geo_service.dart';
import 'package:h8_fli_geo_maps_starter/view/geo_view.dart';
import 'package:h8_fli_geo_maps_starter/view/home_view_manager.dart';
import 'package:h8_fli_geo_maps_starter/view/home_view_staff.dart';
import 'package:h8_fli_geo_maps_starter/view/login_view.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:h8_fli_geo_maps_starter/manager/auth_bloc.dart';
import 'package:h8_fli_geo_maps_starter/domain/usecases/firebase_usecase.dart';
import 'package:h8_fli_geo_maps_starter/data/repositories/firebase_repository_implementation.dart';
import 'package:h8_fli_geo_maps_starter/data/datasources/firebase_data_source.dart';
import 'package:h8_fli_geo_maps_starter/service/nfc_service.dart';
import 'package:h8_fli_geo_maps_starter/manager/nfc_bloc.dart';

final locator = GetIt.instance;

void initDependencyInjection() {
  locator.registerLazySingleton<GeoService>(() => GeoService());
  locator.registerFactory<GeoBloc>(
    () => GeoBloc(service: locator<GeoService>()),
  );
  locator.registerFactory<HistoryBloc>(
    () => HistoryBloc(geoService: locator<GeoService>()),
  );

  // Auth dependencies
  locator.registerLazySingleton<FirebaseDataSource>(() => FirebaseDataSource());
  locator.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImplementation(locator<FirebaseDataSource>()),
  );
  locator.registerLazySingleton<CheckAuthStatusUseCase>(
    () => CheckAuthStatusUseCase(locator<FirebaseRepository>()),
  );
  locator.registerFactory<AuthBloc>(
    () => AuthBloc(checkAuthStatusUseCase: locator<CheckAuthStatusUseCase>()),
  );

  // NFC dependencies
  locator.registerLazySingleton<NfcService>(() => NfcService());
  locator.registerFactory<NfcBloc>(
    () => NfcBloc(locator<NfcService>()),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  initDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<GeoBloc>()),
        BlocProvider(create: (context) => locator<HistoryBloc>()),
        BlocProvider(create: (context) => locator<AuthBloc>()),
        BlocProvider(create: (context) => locator<NfcBloc>()),
      ],
      child: ShadApp.custom(
        themeMode: ThemeMode.dark,
        darkTheme: ShadThemeData(
          brightness: Brightness.dark,
          colorScheme: const ShadZincColorScheme.dark(),
        ),
        appBuilder: (context) {
          return MaterialApp(
            title: 'Geo Hands-On',
            theme: Theme.of(context),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => const LoginView(),
              '/home-staff': (context) => const HomeViewStaff(),
              '/home-manager': (context) => HomeViewManager(),
              '/geo': (context) => const GeoView(),
            },
          );
        },
      ),
    );
  }
}
