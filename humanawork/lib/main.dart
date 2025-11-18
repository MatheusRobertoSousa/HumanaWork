import 'package:flutter/material.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/checkin_page.dart';
import 'presentation/pages/focus_rooms_page.dart';
import 'presentation/pages/focus_rooms_detail_page.dart';
import 'presentation/pages/metrics_page.dart';
// ✅ 1. NOVA IMPORTAÇÃO: Importe o arquivo da tela de criação de sala
import 'presentation/pages/create_focus_room_page.dart'; 

void main() {
  runApp(const HumanaWorkApp());
}

class HumanaWorkApp extends StatelessWidget {
  const HumanaWorkApp({super.key});

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
  title: 'HumanaWork',
  debugShowCheckedModeBanner: false,
  theme: AppTheme.theme,
  initialRoute: AppRoutes.login,

  // Rotas simples, sem argumentos
  routes: {
    AppRoutes.login: (_) => const LoginPage(),
    AppRoutes.home: (_) => const HomePage(),
    AppRoutes.checkin: (_) => const CheckinPage(),
    AppRoutes.focusRooms: (_) => const FocusRoomsPage(),
    AppRoutes.metrics: (_) => const MetricsPage(),
    AppRoutes.createFocusRoom: (_) => const CreateFocusRoomPage(),
  },

  // Rotas que recebem argumentos
  onGenerateRoute: (settings) {
    if (settings.name == AppRoutes.focusRoomDetail) {
      final sala = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => FocusRoomDetailPage(sala: sala),
      );
    }

    // fallback
    return null;
  },
);
  }
}