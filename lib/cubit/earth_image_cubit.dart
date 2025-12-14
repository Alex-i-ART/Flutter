import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/earth_image.dart';
import '../requests/gibs_api.dart';

abstract class EarthImageState extends Equatable {
  const EarthImageState();

  @override
  List<Object> get props => [];
}

class EarthImageInitial extends EarthImageState {}

class EarthImageLoading extends EarthImageState {}

class EarthImageLoaded extends EarthImageState {
  final EarthImage earthImage;
  final bool isRealImage;
  const EarthImageLoaded(this.earthImage, {this.isRealImage = false});

  @override
  List<Object> get props => [earthImage, isRealImage];
}

class EarthImageError extends EarthImageState {
  final String message;
  const EarthImageError(this.message);

  @override
  List<Object> get props => [message];
}

class EarthImageCubit extends Cubit<EarthImageState> {
  EarthImageCubit() : super(EarthImageInitial());

  Future<void> fetchEarthImage(String date) async {
    emit(EarthImageLoading());
    try {
      // Пытаемся получить реальное изображение от NASA
      await _fetchRealNasaImage(date);
    } catch (e) {
      // Если не получается, используем тестовое изображение
      await _useFallbackImage(date, 'Реальное изображение недоступно: $e');
    }
  }

  // Метод для загрузки реального изображения от NASA
  Future<void> _fetchRealNasaImage(String date) async {
    try {
      // Пробуем оба варианта URL
      final imageUrl = GibsApi.buildImageUrl(date: date);
      final alternativeUrl = GibsApi.buildWorldViewImageUrl(date: date);
      
      print('Trying NASA URL: $imageUrl');
      
      final response = await GibsApi.getImage(imageUrl);
      
      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        final earthImage = EarthImage(imageUrl: imageUrl, date: date);
        emit(EarthImageLoaded(earthImage, isRealImage: true));
      } else {
        // Пробуем альтернативный URL
        final altResponse = await GibsApi.getImage(alternativeUrl);
        if (altResponse.statusCode == 200 && altResponse.bodyBytes.isNotEmpty) {
          final earthImage = EarthImage(imageUrl: alternativeUrl, date: date);
          emit(EarthImageLoaded(earthImage, isRealImage: true));
        } else {
          throw Exception('NASA API returned status: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Failed to fetch NASA image: $e');
    }
  }

  // Метод для использования запасного изображения
  Future<void> _useFallbackImage(String date, String error) async {
    try {
      final testImageUrl = GibsApi.getTestImageUrl();
      final earthImage = EarthImage(
        imageUrl: testImageUrl, 
        date: '$date (тестовое изображение)'
      );
      emit(EarthImageLoaded(earthImage, isRealImage: false));
      
      // Также показываем ошибку в консоли для отладки
      print('Fallback to test image. Error: $error');
    } catch (e) {
      emit(EarthImageError('Ошибка загрузки: $e'));
    }
  }

  // Метод для загрузки тестового изображения
  Future<void> fetchTestImage() async {
    emit(EarthImageLoading());
    try {
      final testImageUrl = GibsApi.getTestImageUrl();
      final earthImage = EarthImage(
        imageUrl: testImageUrl, 
        date: 'Тестовое изображение'
      );
      emit(EarthImageLoaded(earthImage, isRealImage: false));
    } catch (e) {
      emit(EarthImageError('Ошибка загрузки тестового изображения: $e'));
    }
  }
}