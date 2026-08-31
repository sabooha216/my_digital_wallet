import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // استدعاء مكتبة الترجمة

class HomeScreen extends StatelessWidget {
  final VoidCallback onThemeChanged;
  final bool isDarkMode;
  final VoidCallback onLanguageChanged; 

  const HomeScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    // تخزين الترجمة في متغير لسهولة الاستخدام وتقليل طول الكود
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myWallet, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent, 
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: onLanguageChanged,
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: onThemeChanged,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
          )
        ],
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رسالة الترحيب أصبحت تقرأ من ملف الترجمة (عامة لأي مستخدم)
            Text(
              l10n.welcome, 
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // بطاقة الرصيد
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.currentBalance, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('\$1,250.00', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Icon(Icons.credit_card, color: Colors.white70, size: 20),
                      SizedBox(width: 8),
                      Text('**** **** **** 1234', style: TextStyle(color: Colors.white70, letterSpacing: 2)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // أزرار العمليات السريعة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(context, Icons.send, l10n.send, Colors.orange),
                _buildActionButton(context, Icons.account_balance_wallet, l10n.receive, Colors.green),
                _buildActionButton(context, Icons.receipt, l10n.bills, Colors.purple),
                _buildActionButton(context, Icons.add_circle_outline, l10n.topUp, Colors.blue),
              ],
            ),
            const SizedBox(height: 30),

            // عنوان سجل العمليات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.recentTransactions, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: Text(l10n.viewAll)),
              ],
            ),
            const SizedBox(height: 10),

            // قائمة العمليات الوهمية (تركنا بياناتها ثابتة مؤقتاً لتتخيلي شكل التصميم)
            _buildTransactionItem('شراء قهوة', 'اليوم، 09:30 ص', '-\$4.50', Colors.red, Icons.coffee),
            _buildTransactionItem('تحويل من أحمد', 'أمس، 02:15 م', '+\$150.00', Colors.green, Icons.arrow_downward),
            _buildTransactionItem('اشتراك منصة تعليمية', '28 أغسطس', '-\$12.99', Colors.red, Icons.school),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color) {
    return Column(
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
    );
  }

  Widget _buildTransactionItem(String title, String date, String amount, Color amountColor, IconData icon) {
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
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blueGrey),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date, style: const TextStyle(fontSize: 12)),
        trailing: Text(amount, style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}