import 'package:flutter/material.dart';

/// Enum untuk membedakan tipe transaksi
enum TransactionType {
  income,
  expense,
}

/// Model data transaksi untuk aplikasi Duitly
class TransactionModel {
  final String id;
  final String title;
  final TransactionType type;
  final int amount;
  final String category;
  final DateTime date;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
  });

  bool get isIncome => type == TransactionType.income;

  /// Format angka nominal menjadi format mata uang Rupiah (contoh: Rp1.500.000)
  String get formattedAmount {
    final str = amount.abs().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp${buffer.toString()}';
  }

  /// Format tanggal menjadi format yang mudah dibaca (contoh: 11 Nov 2026)
  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Ikon representatif berdasarkan kategori transaksi
  IconData get categoryIcon {
    switch (category) {
      case 'Makanan':
        return Icons.restaurant_rounded;
      case 'Transportasi':
        return Icons.directions_bus_rounded;
      case 'Pendidikan':
        return Icons.school_rounded;
      case 'Hiburan':
        return Icons.movie_creation_rounded;
      case 'Uang Saku':
        return Icons.account_balance_wallet_rounded;
      case 'Lainnya':
      default:
        return Icons.category_rounded;
    }
  }

  /// Fungsi untuk menyalin objek dengan perubahan data (berguna untuk fitur Edit)
  TransactionModel copyWith({
    String? id,
    String? title,
    TransactionType? type,
    int? amount,
    String? category,
    DateTime? date,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
}
