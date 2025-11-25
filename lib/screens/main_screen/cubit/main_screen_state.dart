abstract class MainScreenState {
  const MainScreenState();
}

class MainScreenUpdateCounterState extends MainScreenState {
  final int value;
  
  const MainScreenUpdateCounterState({required this.value});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MainScreenUpdateCounterState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'MainScreenUpdateCounterState(value: $value)';
}

class MainScreenInitialState extends MainScreenState {
  const MainScreenInitialState();
}