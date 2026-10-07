import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'services/classifier_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Kunci orientasi potret untuk kemudahan operasional di sawah
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inisialisasi service classifier lokal
  final classifierService = ClassifierService();
  await classifierService.loadModel();

  runApp(PadiCareApp(classifierService: classifierService));
}

class PadiCareApp extends StatelessWidget {
  final ClassifierService classifierService;

  const PadiCareApp({
    super.key,
    required this.classifierService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PadiCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: HomeScreen(classifierService: classifierService),
    );
  }
}
