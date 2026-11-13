import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../state/transaction_state.dart';
import '../theme/app_theme.dart';
import 'add_transaction_screen.dart';
import 'transaction_detail_screen.dart';

/// Halaman Seluruh Transaksi Duitly
/// Menampilkan daftar seluruh transaksi dengan filter dinamis (Semua, Pemasukan, Pengeluaran)
/// serta navigasi ke detail transaksi dan penambahan transaksi baru.
class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  // Pilihan filter: 0 = Semua, 1 = Pemasukan, 2 = Pengeluaran
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = TransactionProvider.of(context);
    final allTransactions = state.transactions;

    // Filter daftar transaksi sesuai pilihan user
    final filteredList = allTransactions.where((t) {
      if (_selectedFilterIndex == 1) {
        return t.type == TransactionType.income;
      } else if (_selectedFilterIndex == 2) {
        return t.type == TransactionType.expense;
      }
      return true; // 0 = Semua
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Daftar Transaksi'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
        backgroundColor: AppTheme.navy,
        foregroundColor: AppTheme.white,
        tooltip: 'Tambah Transaksi',
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Bar (Semua, Pemasukan, Pengeluaran)
            Container(
              color: AppTheme.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  _buildFilterChip('Semua', 0, allTransactions.length),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Pemasukan',
                    1,
                    allTransactions
                        .where((t) => t.type == TransactionType.income)
                        .length,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Pengeluaran',
                    2,
                    allTransactions
                        .where((t) => t.type == TransactionType.expense)
                        .length,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E9F0)),

            // Daftar Transaksi
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredList.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return _buildItemCard(context, item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index, int count) {
    final isSelected = _selectedFilterIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilterIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.navy : AppTheme.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '$label ($count)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppTheme.white : AppTheme.secondaryText,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.blue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: AppTheme.secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak Ada Transaksi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.mainText,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tidak ditemukan transaksi pada kategori ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, TransactionModel item) {
    final isIncome = item.isIncome;
    final amountColor = isIncome ? AppTheme.income : AppTheme.expense;
    final prefix = isIncome ? '+' : '-';

    return Card(
      elevation: 0,
      color: AppTheme.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.04)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TransactionDetailScreen(transactionId: item.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              // Ikon Kategori
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (isIncome ? AppTheme.income : AppTheme.expense)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.categoryIcon,
                  color: isIncome ? AppTheme.income : AppTheme.expense,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              // Nama & Kategori Transaksi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.mainText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.category,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.formattedDate,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Nominal Transaksi
              Text(
                '$prefix${item.formattedAmount}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: amountColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
