import 'package:flutter/material.dart';
import '../state/transaction_state.dart';
import '../theme/app_theme.dart';
import 'add_transaction_screen.dart';

/// Halaman Detail Transaksi Duitly
/// Menampilkan rincian transaksi lengkap dan fitur aksi Edit serta Hapus Transaksi (dengan dialog konfirmasi).
class TransactionDetailScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  void _showDeleteDialog(BuildContext context, TransactionState state) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppTheme.expense),
              SizedBox(width: 8),
              Text(
                'Konfirmasi Hapus',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin menghapus transaksi ini? Tindakan ini tidak dapat dibatalkan.',
            style: TextStyle(color: AppTheme.mainText, fontSize: 14),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: AppTheme.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Tutup dialog
                Navigator.of(dialogContext).pop();
                // Hapus data dari state
                state.deleteTransaction(transactionId);
                // Kembali ke halaman sebelumnya
                Navigator.of(context).pop();

                // Notifikasi sukses
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaksi berhasil dihapus.'),
                    backgroundColor: AppTheme.expense,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.expense,
                foregroundColor: AppTheme.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TransactionProvider.of(context);
    final transaction = state.getById(transactionId);

    // Antisipasi jika transaksi sudah dihapus
    if (transaction == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(title: const Text('Detail Transaksi')),
        body: const Center(
          child: Text(
            'Transaksi tidak ditemukan.',
            style: TextStyle(color: AppTheme.secondaryText),
          ),
        ),
      );
    }

    final isIncome = transaction.isIncome;
    final typeColor = isIncome ? AppTheme.income : AppTheme.expense;
    final typeLabel = isIncome ? 'Pemasukan' : 'Pengeluaran';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        actions: [
          IconButton(
            tooltip: 'Hapus Transaksi',
            icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.expense),
            onPressed: () => _showDeleteDialog(context, state),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card Nominal
              Container(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Ikon Kategori Besar
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        transaction.categoryIcon,
                        color: typeColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Badge Tipe
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        typeLabel,
                        style: TextStyle(
                          color: typeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Nominal Besar
                    Text(
                      '${isIncome ? '+' : '-'}${transaction.formattedAmount}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Nama Transaksi
                    Text(
                      transaction.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.mainText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Rincian Informasi Transaksi
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.title_rounded,
                      label: 'Nama Transaksi',
                      value: transaction.title,
                    ),
                    const Divider(height: 24, color: Color(0xFFEDF1F7)),
                    _buildDetailRow(
                      icon: Icons.category_rounded,
                      label: 'Kategori',
                      value: transaction.category,
                    ),
                    const Divider(height: 24, color: Color(0xFFEDF1F7)),
                    _buildDetailRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Tanggal Transaksi',
                      value: transaction.formattedDate,
                    ),
                    const Divider(height: 24, color: Color(0xFFEDF1F7)),
                    _buildDetailRow(
                      icon: Icons.swap_horiz_rounded,
                      label: 'Jenis Transaksi',
                      value: typeLabel,
                    ),
                    const Divider(height: 24, color: Color(0xFFEDF1F7)),
                    _buildDetailRow(
                      icon: Icons.tag_rounded,
                      label: 'ID Transaksi',
                      value: transaction.id,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Edit Transaksi
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddTransactionScreen(
                        initialTransaction: transaction,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Edit Transaksi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navy,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),

              // Tombol Hapus Transaksi (Outlined)
              OutlinedButton.icon(
                onPressed: () => _showDeleteDialog(context, state),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Hapus Transaksi'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.expense,
                  side: const BorderSide(color: AppTheme.expense),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.secondaryText),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.secondaryText,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.mainText,
            ),
          ),
        ),
      ],
    );
  }
}
