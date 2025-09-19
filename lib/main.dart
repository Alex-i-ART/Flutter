import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Лабораторная работа'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Текстовые виджеты в Column
            Column(
              children: [
                Text('ФИО: Перфильев Александр Леонидович', style: TextStyle(fontSize: 20)),
                Text('Год рождения: 2004', style: TextStyle(fontSize: 20)),
                Text('Группа: ИСТУ-22-2', style: TextStyle(fontSize: 20)),
                SizedBox(height: 20), 
              ],
            ),

            // Виджеты Row с иконками
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.star, size: 30, color: Colors.amber),
                    Icon(Icons.favorite, size: 30, color: Colors.red),
                    Icon(Icons.home, size: 30, color: Colors.blue),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.email, size: 30, color: Colors.green),
                    Icon(Icons.phone, size: 30, color: Colors.purple),
                    Icon(Icons.person, size: 30, color: Colors.orange),
                  ],
                ),
                SizedBox(height: 20), 
              ],
            ),
            
            // Виджет Stack с контейнерами
            Stack(
              alignment: Alignment.center,
              children: [
                Container(color: Colors.red, width: 200, height: 200),
                Container(color: Colors.green, width: 150, height: 150),
                Container(color: Colors.blue, width: 100, height: 100),
                Text('Stack Example', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),

            // НОВЫЙ Stack с контейнерами по углам
            Container(
              height: 300, // Высота для Stack
              child: Stack(
                children: [
                  // Левый верхний угол
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.red,
                      child: Center(child: Text('ЛВ', style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  
                  // Правый верхний угол
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 100,
                      height: 70,
                      color: Colors.blue,
                      child: Center(child: Text('ПВ', style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  
                  // Левый нижний угол
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 90,
                      height: 90,
                      color: Colors.green,
                      child: Center(child: Text('ЛН', style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  
                  // Правый нижний угол
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 70,
                      height: 100,
                      color: Colors.orange,
                      child: Center(child: Text('ПН', style: TextStyle(color: Colors.white))),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), 

            // Текстовые виджеты в Wrap
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.amber,
                  child: Text('ФИО: Перфиьев Александр Леоинидович'),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.lightBlue,
                  child: Text('Год рождения: 2004'),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.lightGreen,
                  child: Text('Группа: ИСТУ-22-2'),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.pinkAccent,
                  child: Text('Специальность: Программист'),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.deepPurpleAccent,
                  child: Text('Курс: 4'),
                ),
              ],
            ),

            // Original Wrap с цветными контейнерами
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(6, (index) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.primaries[index % Colors.primaries.length],
                  child: Center(child: Text('Container $index', style: TextStyle(color: Colors.white))),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}