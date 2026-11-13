import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/transaction_model.dart';
import '../state/transaction_state.dart';
import '../theme/app_theme.dart';

/// Halaman Tambah / Edit Transaksi Duitly
/// Menyediakan formulir lengkap dengan validasi:
/// - Jenis Transaksi (Pemasukan / Pengeluaran)
/// - Nama Transaksi
/// - Nominal (Harus berupa angka dan > 0)
/// - Kategori
/// - Tanggal Transaksi
class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? initialTransaction;

  const AddTransactionScreen({super.key, this.initialTransaction});

  bool get isEditing => initialTransaction != null;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  late TransactionType _selectedType;
  late String _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialTransaction;
    if (initial != null) {
      _titleController = TextEditingController(text: initial.title);
      _amountController =
          TextEditingController(text: initial.amount.toString());
      _selectedType = initial.type;
      _selectedCategory = initial.category;
      _selectedDate = initial.date;
    } else {
      _titleController = TextEditingController();
      _amountController = TextEditingController();
      _selectedType = TransactionType.expense;
      _selectedCategory = availableCategories.first; // 'Makanan'
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.navy,
              onPrimary: AppTheme.white,
              onSurface: AppTheme.mainText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap periksa kembali input formulir Anda.'),
          backgroundColor: AppTheme.expense,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final amount = int.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nominal harus lebih dari 0.'),
          backgroundColor: AppTheme.expense,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final state = TransactionProvider.of(context);

    if (widget.isEditing) {
      final updated = widget.initialTransaction!.copyWith(
        title: _titleController.text.trim(),
        type: _selectedType,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
      );
      state.updateTransaction(updated);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil diperbarui!'),
          backgroundColor: AppTheme.income,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      final newTrx = TransactionModel(
        id: 'trx-${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        type: _selectedType,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
      );
      state.addTransaction(newTrx);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi baru berhasil ditambahkan!'),
          backgroundColor: AppTheme.income,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final titleText =
        widget.isEditing ? 'Edit Transaksi' : 'Tambah Transaksi';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(titleText),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Pilihan Jenis Transaksi (Toggle Pengeluaran / Pemasukan)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTypeOption(
                          label: 'Pengeluaran',
                          type: TransactionType.expense,
                          activeColor: AppTheme.expense,
                          icon: Icons.arrow_upward_rounded,
                        ),
                      ),
                      Expanded(
                        child: _buildTypeOption(
                          label: 'Pemasukan',
                          type: TransactionType.income,
                          activeColor: AppTheme.income,
                          icon: Icons.arrow_downward_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Input Nama Transaksi
                const Text(
                  'Nama Transaksi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.mainText,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Makan Siang, Beli Buku, dll.',
                    prefixIcon: Icon(
                      Icons.edit_note_rounded,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama transaksi wajib diisi';
                    }
                    if (value.trim().length < 3) {
                      return 'Nama transaksi minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Input Nominal
                const Text(
                  'Nominal Transaksi (Rp)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.mainText,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: 25000',
                    prefixText: 'Rp ',
                    prefixStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.mainText,
                    ),
                    prefixIcon: Icon(
                      Icons.payments_outlined,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nominal wajib diisi';
                    }
                    final num = int.tryParse(value.trim());
                    if (num == null) {
                      return 'Nominal harus berupa angka valid';
                    }
                    if (num <= 0) {
                      return 'Nominal harus lebih dari Rp 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Input Kategori
                const Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.mainText,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.category_outlined,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                  dropdownColor: AppTheme.white,
                  items: availableCategories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCategory = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Input Tanggal
                const Text(
                  'Tanggal Transaksi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.mainText,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.secondaryText.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          color: AppTheme.secondaryText,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatSelectedDate(_selectedDate),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.mainText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Ubah',
                          style: TextStyle(
                            color: AppTheme.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // Tombol Simpan
                ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.navy,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    widget.isEditing
                        ? 'Simpan Perubahan'
                        : 'Tambah Transaksi',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeOption({
    required String label,
    required TransactionType type,
    required Color activeColor,
    required IconData icon,
  }) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppTheme.white : AppTheme.secondaryText,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppTheme.white : AppTheme.secondaryText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSelectedDate(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
