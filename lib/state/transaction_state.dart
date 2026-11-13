import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/transaction_model.dart';

/// State Management untuk transaksi menggunakan ChangeNotifier.
/// Menyimpan, mengelola, dan menghitung data keuangan secara reaktif.
class TransactionState extends ChangeNotifier {
  // Daftar transaksi lokal yang diinisialisasi dari dummy data
  final List<TransactionModel> _transactions = List.from(initialTransactions);

  /// Mengambil salinan daftar seluruh transaksi (terbaru berada di atas)
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  /// Mengambil maksimal 5 transaksi terbaru untuk ditampilkan di Dashboard
  List<TransactionModel> get recentTransactions =>
      _transactions.take(5).toList();

  /// Menghitung total seluruh pemasukan
  int get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, item) => sum + item.amount);
  }

  /// Menghitung total seluruh pengeluaran
  int get totalExpense {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, item) => sum + item.amount);
  }

  /// Menghitung saldo bersih (Total Pemasukan - Total Pengeluaran)
  int get totalBalance => totalIncome - totalExpense;

  /// Mencari transaksi berdasarkan ID
  TransactionModel? getById(String id) {
    try {
      return _transactions.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Menambahkan transaksi baru
  void addTransaction(TransactionModel transaction) {
    // Tambahkan di awal daftar agar menjadi transaksi paling baru
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  /// Memperbarui/mengedit data transaksi yang sudah ada
  void updateTransaction(TransactionModel updated) {
    final index = _transactions.indexWhere((t) => t.id == updated.id);
    if (index != -1) {
      _transactions[index] = updated;
      notifyListeners();
    }
  }

  /// Menghapus transaksi berdasarkan ID
  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

/// Provider sederhana berbasis InheritedNotifier.
/// Memastikan state dapat diakses dan memicu rebuild pada seluruh halaman
/// tanpa hilang saat navigasi atau rotasi layar.
class TransactionProvider extends InheritedNotifier<TransactionState> {
  const TransactionProvider({
    super.key,
    required TransactionState state,
    required super.child,
  }) : super(notifier: state);

  /// Method statis untuk mengakses TransactionState dari BuildContext mana pun
  static TransactionState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<TransactionProvider>();
    assert(
      provider != null,
      'TransactionProvider tidak ditemukan di dalam widget tree.',
    );
    return provider!.notifier!;
  }
}
