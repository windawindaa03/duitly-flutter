import '../models/transaction_model.dart';

/// Data awal (dummy data) transaksi sesuai ketentuan ATS Duitly
final List<TransactionModel> initialTransactions = [
  TransactionModel(
    id: 'trx-1',
    title: 'Uang Saku Bulanan',
    type: TransactionType.income,
    amount: 1500000,
    category: 'Uang Saku',
    date: DateTime(2026, 11, 1),
  ),
  TransactionModel(
    id: 'trx-2',
    title: 'Makan Siang',
    type: TransactionType.expense,
    amount: 15000,
    category: 'Makanan',
    date: DateTime(2026, 11, 2),
  ),
  TransactionModel(
    id: 'trx-3',
    title: 'Transportasi',
    type: TransactionType.expense,
    amount: 20000,
    category: 'Transportasi',
    date: DateTime(2026, 11, 3),
  ),
  TransactionModel(
    id: 'trx-4',
    title: 'Uang Hadiah',
    type: TransactionType.income,
    amount: 100000,
    category: 'Lainnya',
    date: DateTime(2026, 11, 5),
  ),
  TransactionModel(
    id: 'trx-5',
    title: 'Alat Tulis',
    type: TransactionType.expense,
    amount: 25000,
    category: 'Pendidikan',
    date: DateTime(2026, 11, 8),
  ),
];

/// Daftar kategori transaksi standar pada aplikasi Duitly
const List<String> availableCategories = [
  'Makanan',
  'Transportasi',
  'Pendidikan',
  'Hiburan',
  'Uang Saku',
  'Lainnya',
];
