import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeChanged;
  final bool isDarkMode;
  final VoidCallback onLanguageChanged;
  final VoidCallback onLogout;
  final String username;

  const HomeScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
    required this.onLanguageChanged,
    required this.onLogout,
    required this.username,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showBalance = true;

  double _balance = 1250.00;

  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'شراء قهوة',
      'date': 'اليوم، 09:30 ص',
      'amount': -4.50,
      'icon': Icons.coffee,
    },
    {
      'title': 'تحويل من أحمد',
      'date': 'أمس، 02:15 م',
      'amount': 150.00,
      'icon': Icons.arrow_downward,
    },
    {
      'title': 'اشتراك منصة تعليمية',
      'date': '28 أغسطس',
      'amount': -12.99,
      'icon': Icons.school,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.myWallet,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: widget.onLanguageChanged,
          ),
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onThemeChanged,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: widget.onLogout,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مرحبًا بك، ${widget.username} 👋',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // بطاقة الرصيد
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.blueAccent,
                    Colors.lightBlue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.currentBalance,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showBalance = !_showBalance;
                          });
                        },
                        icon: Icon(
                          _showBalance
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _showBalance
                        ? '\$${_balance.toStringAsFixed(2)}'
                        : '••••••',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        color: Colors.white70,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '**** **** **** 1234',
                        style: TextStyle(
                          color: Colors.white70,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // العمليات السريعة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  context,
                  Icons.send,
                  l10n.send,
                  Colors.orange,
                  _showSendDialog,
                ),
                _buildActionButton(
                  context,
                  Icons.account_balance_wallet,
                  l10n.receive,
                  Colors.green,
                  _showReceiveDialog,
                ),
                _buildActionButton(
                  context,
                  Icons.receipt,
                  l10n.bills,
                  Colors.purple,
                  _showBillsDialog,
                ),
                _buildActionButton(
                  context,
                  Icons.add_circle_outline,
                  l10n.topUp,
                  Colors.blue,
                  _showTopUpDialog,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // العمليات الأخيرة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.recentTransactions,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _showAllTransactions,
                  child: Text(l10n.viewAll),
                ),
              ],
            ),

            const SizedBox(height: 10),

            ..._transactions.take(3).map(
                  (transaction) => _buildTransactionItem(
                    transaction['title'] as String,
                    transaction['date'] as String,
                    transaction['amount'] as double,
                    transaction['icon'] as IconData,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  // زر العملية
  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // إرسال الأموال
  void _showSendDialog() {
    final recipientController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('إرسال أموال'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: recipientController,
                decoration: const InputDecoration(
                  labelText: 'اسم المستلم',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'المبلغ',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final recipient = recipientController.text.trim();
                final amount = double.tryParse(amountController.text.trim());

                if (recipient.isEmpty || amount == null || amount <= 0) {
                  _showMessage('أدخلي اسم المستلم والمبلغ بشكل صحيح');
                  return;
                }

                if (amount > _balance) {
                  _showMessage('الرصيد غير كافٍ ❌');
                  return;
                }

                setState(() {
                  _balance -= amount;

                  _transactions.insert(0, {
                    'title': 'إرسال إلى $recipient',
                    'date': 'الآن',
                    'amount': -amount,
                    'icon': Icons.send,
                  });
                });

                Navigator.pop(dialogContext);

                _showMessage(
                  'تم إرسال \$${amount.toStringAsFixed(2)} إلى $recipient ✅',
                );
              },
              child: const Text('إرسال'),
            ),
          ],
        );
      },
    );
  }

  // استقبال الأموال
  void _showReceiveDialog() {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('استقبال أموال'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.username,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'رقم المحفظة',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              const SelectableText(
                'MW-1234-5678',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'المبلغ المستلم',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.trim());

                if (amount == null || amount <= 0) {
                  _showMessage('أدخلي مبلغًا صحيحًا');
                  return;
                }

                setState(() {
                  _balance += amount;

                  _transactions.insert(0, {
                    'title': 'استقبال أموال',
                    'date': 'الآن',
                    'amount': amount,
                    'icon': Icons.arrow_downward,
                  });
                });

                Navigator.pop(dialogContext);

                _showMessage(
                  'تم استقبال \$${amount.toStringAsFixed(2)} بنجاح ✅',
                );
              },
              child: const Text('استقبال'),
            ),
          ],
        );
      },
    );
  }

  // الفواتير
  void _showBillsDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('الفواتير'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBillOption(
                dialogContext,
                Icons.bolt,
                'فاتورة الكهرباء',
              ),
              _buildBillOption(
                dialogContext,
                Icons.water_drop,
                'فاتورة الماء',
              ),
              _buildBillOption(
                dialogContext,
                Icons.wifi,
                'فاتورة الإنترنت',
              ),
              _buildBillOption(
                dialogContext,
                Icons.phone,
                'فاتورة الهاتف',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBillOption(
    BuildContext dialogContext,
    IconData icon,
    String title,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.purple,
      ),
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
      onTap: () {
        Navigator.pop(dialogContext);
        _showBillAmountDialog(title);
      },
    );
  }

  void _showBillAmountDialog(String billName) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(billName),
          content: TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'مبلغ الفاتورة',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.trim());

                if (amount == null || amount <= 0) {
                  _showMessage('أدخلي مبلغًا صحيحًا');
                  return;
                }

                if (amount > _balance) {
                  _showMessage('الرصيد غير كافٍ ❌');
                  return;
                }

                setState(() {
                  _balance -= amount;

                  _transactions.insert(0, {
                    'title': billName,
                    'date': 'الآن',
                    'amount': -amount,
                    'icon': Icons.receipt,
                  });
                });

                Navigator.pop(dialogContext);

                _showMessage(
                  'تم دفع $billName بقيمة \$${amount.toStringAsFixed(2)} ✅',
                );
              },
              child: const Text('دفع الفاتورة'),
            ),
          ],
        );
      },
    );
  }

  // شحن المحفظة
  void _showTopUpDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('شحن المحفظة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopUpOption(dialogContext, 10),
              _buildTopUpOption(dialogContext, 25),
              _buildTopUpOption(dialogContext, 50),
              _buildTopUpOption(dialogContext, 100),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopUpOption(
    BuildContext dialogContext,
    double amount,
  ) {
    return ListTile(
      leading: const Icon(
        Icons.add_circle,
        color: Colors.blue,
      ),
      title: Text(
        '\$${amount.toStringAsFixed(2)}',
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
      onTap: () {
        setState(() {
          _balance += amount;

          _transactions.insert(0, {
            'title': 'شحن المحفظة',
            'date': 'الآن',
            'amount': amount,
            'icon': Icons.add_circle,
          });
        });

        Navigator.pop(dialogContext);

        _showMessage(
          'تم شحن المحفظة بقيمة \$${amount.toStringAsFixed(2)} بنجاح ✅',
        );
      },
    );
  }

  // عرض جميع العمليات
  void _showAllTransactions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'جميع العمليات',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: _transactions.isEmpty
                        ? const Center(
                            child: Text('لا توجد عمليات'),
                          )
                        : ListView.builder(
                            itemCount: _transactions.length,
                            itemBuilder: (context, index) {
                              final transaction =
                                  _transactions[index];

                              return _buildTransactionItem(
                                transaction['title'] as String,
                                transaction['date'] as String,
                                transaction['amount'] as double,
                                transaction['icon'] as IconData,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // عنصر العملية
  Widget _buildTransactionItem(
    String title,
    String date,
    double amount,
    IconData icon,
  ) {
    final bool isIncome = amount >= 0;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          date,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // رسالة صغيرة للمستخدم
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}