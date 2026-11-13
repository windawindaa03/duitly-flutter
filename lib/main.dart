import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'state/transaction_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DuitlyApp());
}

/// Root Widget Aplikasi Duitly
/// Menggunakan StatefulWidget agar TransactionState hanya diinisialisasi satu kali
/// selama siklus hidup aplikasi (Lifecycle & State Management terjaga saat rotasi dan navigasi).
class DuitlyApp extends StatefulWidget {
  const DuitlyApp({super.key});

  @override
  State<DuitlyApp> createState() => _DuitlyAppState();
}

class _DuitlyAppState extends State<DuitlyApp> {
  // Inisialisasi state transaksi satu kali untuk seluruh aplikasi
  late final TransactionState _transactionState;

  @override
  void initState() {
    super.initState();
    _transactionState = TransactionState();
  }

  @override
  void dispose() {
    _transactionState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TransactionProvider(
      state: _transactionState,
      child: MaterialApp(
        title: 'Duitly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
