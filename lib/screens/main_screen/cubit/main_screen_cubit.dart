import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen_state.dart';
import 'package:flutter_application/database/db_provider.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(const MainScreenUpdateCounterState(value: 0));
  
  final DBProvider dbProvider = DBProvider.db;
  
  // Загружаем счетчик при создании кубита
  Future<void> loadCounter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final counter = prefs.getInt('counter') ?? 0;
      print('Loaded counter: $counter'); // Добавим отладочный вывод
      emit(MainScreenUpdateCounterState(value: counter));
    } catch (e) {
      print('Error loading counter: $e');
      emit(const MainScreenUpdateCounterState(value: 0));
    }
  }
  
  Future<void> addValue() async {
    try {
      final currentState = state as MainScreenUpdateCounterState;
      final previousValue = currentState.value;
      final newValue = currentState.value + 1;
      
      print('Adding value: $previousValue -> $newValue'); // Отладочный вывод
      
      // СРАЗУ обновляем состояние
      emit(MainScreenUpdateCounterState(value: newValue));
      
      // Затем сохраняем данные
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('counter', newValue);
      await dbProvider.addHistory('INCREMENT', previousValue, newValue);
      
      print('State after add: ${(state as MainScreenUpdateCounterState).value}'); // Проверка
    } catch (e) {
      print('Error in addValue: $e');
    }
  }
  
  Future<void> removeValue() async {
    try {
      final currentState = state as MainScreenUpdateCounterState;
      final previousValue = currentState.value;
      final newValue = currentState.value - 1;
      
      print('Removing value: $previousValue -> $newValue'); // Отладочный вывод
      
      // СРАЗУ обновляем состояние
      emit(MainScreenUpdateCounterState(value: newValue));
      
      // Затем сохраняем данные
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('counter', newValue);
      await dbProvider.addHistory('DECREMENT', previousValue, newValue);
      
      print('State after remove: ${(state as MainScreenUpdateCounterState).value}'); // Проверка
    } catch (e) {
      print('Error in removeValue: $e');
    }
  }
  
  // Получаем историю операций
  Future<List<Map<String, dynamic>>> getHistory() async {
    return await dbProvider.getAllHistory();
  }
}