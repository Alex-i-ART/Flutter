import 'package:flutter/material.dart';
import '../main_screen/cubit/main_screen_cubit.dart';

class HistoryScreen extends StatelessWidget {
  final MainScreenCubit mainScreenCubit;
  
  const HistoryScreen({super.key, required this.mainScreenCubit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История операций'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: mainScreenCubit.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return const Center(child: Text('Ошибка загрузки истории'));
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('История операций пуста'));
          }
          
          final history = snapshot.data!;
          
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(
                    item['operation'] == 'INCREMENT' 
                      ? Icons.add 
                      : Icons.remove,
                    color: item['operation'] == 'INCREMENT' 
                      ? Colors.green 
                      : Colors.red,
                  ),
                  title: Text(
                    item['operation'] == 'INCREMENT' ? 'Увеличение' : 'Уменьшение',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Было: ${item['previous_value']} → Стало: ${item['new_value']}',
                  ),
                  trailing: Text(
                    _formatDate(item['timestamp']),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  String _formatDate(String timestamp) {
    final date = DateTime.parse(timestamp);
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}