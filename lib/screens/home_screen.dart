import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../database/database_helper.dart';

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
  double _balance = 0.0;
  
  String _fullName = '';
  String _dob = '';
  String _phone = '';
  String _birthPlaceDate = '';
  String _currentLocation = '';
  
  List<Map<String, dynamic>> _transactions = [];
  String _searchQuery = ''; 

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ==========================================
  // دالة الترجمة المبسطة والذكية
  // ==========================================
  String _tr(String ar, String en) {
    // نتحقق من لغة التطبيق الحالية
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic ? ar : en;
  }

  // دالة صغيرة لترجمة كلمة "غير محدد"
  String _displayValue(String value) {
    if (value.isEmpty || value == 'غير محدد') {
      return _tr('غير محدد', 'Not specified');
    }
    return value;
  }

  Future<void> _loadData() async {
    final dbHelper = DatabaseHelper.instance;
    
    final user = await dbHelper.getUserByName(widget.username);
    if (user != null) {
      setState(() {
        _balance = user[DatabaseHelper.columnBalance];
        _fullName = user[DatabaseHelper.columnFullName] ?? 'غير محدد';
        _dob = user[DatabaseHelper.columnDob] ?? 'غير محدد';
        _phone = user[DatabaseHelper.columnPhone] ?? 'غير محدد';
        _birthPlaceDate = user[DatabaseHelper.columnBirthPlaceDate] ?? 'غير محدد';
        _currentLocation = user[DatabaseHelper.columnCurrentLocation] ?? 'غير محدد';
      });
    }

    final trans = await dbHelper.getTransactionsByUser(widget.username);
    setState(() {
      _transactions = trans.map((t) {
        IconData icon;
        switch(t['type']) {
          case 'send': icon = Icons.send; break;
          case 'receive': icon = Icons.arrow_downward; break;
          case 'bill': icon = Icons.receipt; break;
          case 'topup': icon = Icons.add_circle; break;
          default: icon = Icons.payment;
        }
        return {
          'title': t['title'],
          'date': t['date'],
          'amount': t['amount'],
          'icon': icon,
        };
      }).toList();
    });
  }

  Future<void> _processTransaction({
    required String title,
    required double amount,
    required String type,
  }) async {
    final dbHelper = DatabaseHelper.instance;
    
    double newBalance = _balance + amount;
    await dbHelper.updateBalance(widget.username, newBalance);

    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    await dbHelper.insertTransaction({
      DatabaseHelper.transUsername: widget.username,
      DatabaseHelper.transTitle: title,
      DatabaseHelper.transAmount: amount,
      DatabaseHelper.transDate: dateStr,
      DatabaseHelper.transType: type,
    });

    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    List<Map<String, dynamic>> searchResults = [];
    if (_searchQuery == '') {
      searchResults = _transactions;
    } else {
      searchResults = _transactions.where((transaction) {
        String title = transaction['title'].toString().toLowerCase();
        return title.contains(_searchQuery.toLowerCase()); 
      }).toList();
    }

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: _showUserProfile, 
              borderRadius: BorderRadius.circular(50),
              child: const CircleAvatar(
                backgroundColor: Color(0xFF4A00E0),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
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
              '${_tr('مرحبًا بك،', 'Welcome,')} ${widget.username} 👋',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)], 
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A00E0).withOpacity(0.4), 
                    blurRadius: 15,
                    offset: const Offset(0, 8),
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
                          _showBalance ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _showBalance ? '\$${_balance.toStringAsFixed(2)}' : '••••••',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Icon(Icons.credit_card, color: Colors.white70, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '**** **** **** 1234',
                        style: TextStyle(color: Colors.white70, letterSpacing: 2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(context, Icons.send, l10n.send, Colors.orange, _showSendDialog),
                _buildActionButton(context, Icons.account_balance_wallet, l10n.receive, Colors.green, _showReceiveDialog),
                _buildActionButton(context, Icons.receipt, l10n.bills, Colors.purple, _showBillsDialog),
                _buildActionButton(context, Icons.add_circle_outline, l10n.topUp, Colors.blue, _showTopUpDialog),
              ],
            ),
            const SizedBox(height: 30),

            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: _tr('ابحث عن عملية (مثال: كهرباء، ماء...)', 'Search (e.g., electricity, water...)'),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF4A00E0)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.recentTransactions,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _showAllTransactions,
                  child: Text(l10n.viewAll),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            if (_transactions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(_tr('لا توجد عمليات سابقة', 'No previous transactions'), style: const TextStyle(color: Colors.grey)),
                ),
              )
            else if (searchResults.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(_tr('لم يتم العثور على العملية 🔍', 'No transactions found 🔍'), style: const TextStyle(color: Colors.grey)),
                ),
              )
            else
              ...searchResults.take(5).map((transaction) {
                return _buildTransactionItem(
                  transaction['title'] as String,
                  transaction['date'] as String,
                  transaction['amount'] as double,
                  transaction['icon'] as IconData,
                );
              }),
          ],
        ),
      ),
    );
  }

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
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // نافذة الملف الشخصي 
  void _showUserProfile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              
              const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFF4A00E0),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                _fullName.isEmpty || _fullName == 'غير محدد' ? widget.username : _fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '@${widget.username}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // البطاقات مع الترجمة
              _buildProfileInfoTile(Icons.person_outline, _tr('الاسم الرباعي', 'Full Name'), _displayValue(_fullName)),
              _buildProfileInfoTile(Icons.calendar_today, _tr('تاريخ الميلاد', 'Date of Birth'), _displayValue(_dob)),
              _buildProfileInfoTile(Icons.phone, _tr('رقم الجوال', 'Phone Number'), _displayValue(_phone)),
              _buildProfileInfoTile(Icons.cake_outlined, _tr('مكان وتاريخ الميلاد', 'Place & Date of Birth'), _displayValue(_birthPlaceDate)),
              _buildProfileInfoTile(Icons.location_on_outlined, _tr('الموقع الحالي', 'Current Location'), _displayValue(_currentLocation)),
              
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileInfoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF4A00E0).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF4A00E0)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // --- النوافذ المنبثقة للعمليات ---

  void _showSendDialog() {
    final recipientController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(_tr('إرسال أموال', 'Send Money')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: recipientController,
                decoration: InputDecoration(
                  labelText: _tr('اسم المستلم', 'Recipient Name'),
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: _tr('المبلغ', 'Amount'),
                  prefixIcon: const Icon(Icons.attach_money),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(_tr('إلغاء', 'Cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                final recipient = recipientController.text.trim();
                final amount = double.tryParse(amountController.text.trim());

                if (recipient.isEmpty || amount == null || amount <= 0) {
                  _showMessage(_tr('أدخلي اسم المستلم والمبلغ بشكل صحيح', 'Please enter valid name and amount'));
                  return;
                }
                if (amount > _balance) {
                  _showMessage(_tr('الرصيد غير كافٍ ❌', 'Insufficient balance ❌'));
                  return;
                }

                Navigator.pop(dialogContext);
                await _processTransaction(
                  title: '${_tr('إرسال إلى', 'Send to')} $recipient',
                  amount: -amount,
                  type: 'send',
                );
                _showMessage('${_tr('تم إرسال', 'Successfully sent')} \$${amount.toStringAsFixed(2)}');
              },
              child: Text(_tr('إرسال', 'Send')),
            ),
          ],
        );
      },
    );
  }

  void _showReceiveDialog() {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(_tr('استقبال أموال', 'Receive Money')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.green,
                child: Icon(Icons.account_balance_wallet, color: Colors.white, size: 35),
              ),
              const SizedBox(height: 16),
              Text(widget.username, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_tr('رقم المحفظة', 'Wallet Number'), style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              const SelectableText('MW-1234-5678', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: _tr('المبلغ المستلم', 'Amount to receive'),
                  prefixIcon: const Icon(Icons.attach_money),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(_tr('إلغاء', 'Cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text.trim());

                if (amount == null || amount <= 0) {
                  _showMessage(_tr('أدخلي مبلغًا صحيحًا', 'Please enter a valid amount'));
                  return;
                }

                Navigator.pop(dialogContext);
                await _processTransaction(title: _tr('استقبال أموال', 'Money Received'), amount: amount, type: 'receive');
                _showMessage('${_tr('تم استقبال', 'Successfully received')} \$${amount.toStringAsFixed(2)}');
              },
              child: Text(_tr('استقبال', 'Receive')),
            ),
          ],
        );
      },
    );
  }

  void _showBillsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, 
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50, height: 5,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 20),
              Text(_tr('سداد الفواتير', 'Pay Bills'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildJeebBillOption(sheetContext, Icons.bolt, _tr('فاتورة الكهرباء', 'Electricity Bill'), Colors.orange),
              _buildJeebBillOption(sheetContext, Icons.water_drop, _tr('فاتورة المياه', 'Water Bill'), Colors.blue),
              _buildJeebBillOption(sheetContext, Icons.wifi, _tr('فاتورة الإنترنت', 'Internet Bill'), Colors.green),
              _buildJeebBillOption(sheetContext, Icons.phone_android, _tr('فاتورة الهاتف', 'Phone Bill'), Colors.purple),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJeebBillOption(BuildContext dialogContext, IconData icon, String title, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 26),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), shape: BoxShape.circle),
          child: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ),
        onTap: () {
          Navigator.pop(dialogContext); 
          _showBillAmountDialog(title); 
        },
      ),
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: _tr('مبلغ الفاتورة', 'Bill Amount'),
              prefixIcon: const Icon(Icons.attach_money),
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(_tr('إلغاء', 'Cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text.trim());

                if (amount == null || amount <= 0) {
                  _showMessage(_tr('أدخلي مبلغًا صحيحًا', 'Please enter a valid amount'));
                  return;
                }
                if (amount > _balance) {
                  _showMessage(_tr('الرصيد غير كافٍ ❌', 'Insufficient balance ❌'));
                  return;
                }

                Navigator.pop(dialogContext);
                await _processTransaction(title: billName, amount: -amount, type: 'bill');
                _showMessage('${_tr('تم دفع', 'Successfully paid')} $billName');
              },
              child: Text(_tr('دفع الفاتورة', 'Pay Bill')),
            ),
          ],
        );
      },
    );
  }

  void _showTopUpDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(_tr('شحن المحفظة', 'Top Up Wallet')),
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
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(_tr('إلغاء', 'Cancel'))),
          ],
        );
      },
    );
  }

  Widget _buildTopUpOption(BuildContext dialogContext, double amount) {
    return ListTile(
      leading: const Icon(Icons.add_circle, color: Colors.blue),
      title: Text('\$${amount.toStringAsFixed(2)}'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () async {
        Navigator.pop(dialogContext);
        await _processTransaction(title: _tr('شحن المحفظة', 'Wallet Top Up'), amount: amount, type: 'topup');
        _showMessage('${_tr('تم شحن المحفظة بقيمة', 'Wallet topped up by')} \$${amount.toStringAsFixed(2)}');
      },
    );
  }

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
                  Text(_tr('جميع العمليات', 'All Transactions'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _transactions.isEmpty
                        ? Center(child: Text(_tr('لا توجد عمليات', 'No transactions')))
                        : ListView.builder(
                            itemCount: _transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = _transactions[index];
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

  Widget _buildTransactionItem(String title, String date, double amount, IconData icon) {
    final bool isIncome = amount >= 0;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: isIncome ? Colors.green : Colors.red),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date, style: const TextStyle(fontSize: 12)),
        trailing: Text(
          '${isIncome ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(color: isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }
}