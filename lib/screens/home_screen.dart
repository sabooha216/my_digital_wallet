
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onThemeChanged;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. الشريط العلوي (AppBar)
      appBar: AppBar(
        title: const Text('محفظتي', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent, // شفاف ليأخذ لون الخلفية
        actions: [
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
      
      // جسم الشاشة (قابل للتمرير لتجنب الأخطاء في الشاشات الصغيرة)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رسالة الترحيب
            const Text(
              'مرحباً، صباح 👋', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 2. بطاقة الرصيد (Balance Card)
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
                  const Text('الرصيد الحالي', style: TextStyle(color: Colors.white70, fontSize: 16)),
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

            // 3. أزرار العمليات السريعة (Quick Actions)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(context, Icons.send, 'إرسال', Colors.orange),
                _buildActionButton(context, Icons.account_balance_wallet, 'استقبال', Colors.green),
                _buildActionButton(context, Icons.receipt, 'فواتير', Colors.purple),
                _buildActionButton(context, Icons.add_circle_outline, 'شحن', Colors.blue),
              ],
            ),
            const SizedBox(height: 30),

            // 4. سجل العمليات (Transactions)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('آخر العمليات', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('عرض الكل')),
              ],
            ),
            const SizedBox(height: 10),

            // قائمة العمليات الوهمية (للتصميم حالياً)
            _buildTransactionItem('شراء قهوة', 'اليوم، 09:30 ص', '-\$4.50', Colors.red, Icons.coffee),
            _buildTransactionItem('تحويل من أحمد', 'أمس، 02:15 م', '+\$150.00', Colors.green, Icons.arrow_downward),
            _buildTransactionItem('اشتراك منصة تعليمية', '28 أغسطس', '-\$12.99', Colors.red, Icons.school),
          ],
        ),
      ),
    );
  }

  // --- دوال مساعدة لترتيب الكود وتجنب التكرار ---

  // دالة تصميم زر العملية السريعة
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

  // دالة تصميم صف عملية الدفع
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