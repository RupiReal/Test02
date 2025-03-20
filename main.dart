import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(BankingApp());
}

class BankingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Banking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, size: 80, color: Colors.blue),
            SizedBox(height: 10),
            Text('Welcome to Mobile Banking', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Date: ${DateTime.now().toLocal().toString().split(" ")[0]}', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountListScreen()),
                );
              },
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12)),
              child: Text('View Accounts', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> accounts = List<Map<String, dynamic>>.from(
      json.decode('[{"id":1,"name":"Savings Account","balance":1500.50},{"id":2,"name":"Checking Account","balance":2300.75}]')
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Accounts')),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(accounts[index]['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text('Balance: \$${accounts[index]['balance'].toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.green, fontSize: 16)),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailsScreen(accountId: accounts[index]['id']),
                    ),
                  );
                },
                child: Text('View Transactions'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TransactionDetailsScreen extends StatelessWidget {
  final int accountId;
  TransactionDetailsScreen({required this.accountId});

  final List<Map<String, dynamic>> transactions = List<Map<String, dynamic>>.from(
    json.decode('[{"accountId":1,"date":"2025-03-01","amount":100.00,"description":"Deposit"},{"accountId":1,"date":"2025-03-03","amount":-50.00,"description":"Grocery Store"},{"accountId":2,"date":"2025-03-02","amount":500.00,"description":"Salary"}]')
  );

  @override
  Widget build(BuildContext context) {
    var accountTransactions = transactions.where((t) => t['accountId'] == accountId).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Transaction History')),
      body: accountTransactions.isEmpty
          ? Center(child: Text('No transactions available', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: accountTransactions.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(accountTransactions[index]['description'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    subtitle: Text('Date: ${accountTransactions[index]['date']}', style: TextStyle(color: Colors.grey[700])),
                    trailing: Text(
                      '\$${accountTransactions[index]['amount'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        color: accountTransactions[index]['amount'] < 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
