import 'package:http/http.dart' as http;

class GibsApi {
  // Функция для формирования URL изображения Земли с правильными параметрами
  static String buildImageUrl({required String date}) {
    const baseUrl = 'https://gibs.earthdata.nasa.gov/wms/epsg4326/best/wms.cgi';
    
    final params = {
      'SERVICE': 'WMS',
      'VERSION': '1.1.1', // Используем более старую версию
      'REQUEST': 'GetMap',
      'LAYERS': 'MODIS_Terra_CorrectedReflectance_TrueColor',
      'SRS': 'EPSG:4326', // Для версии 1.1.1 используем SRS вместо CRS
      'BBOX': '-180,-90,180,90', // Полный охват Земли
      'WIDTH': '800',
      'HEIGHT': '600',
      'FORMAT': 'image/jpeg',
      'TIME': date,
      'TRANSPARENT': 'false',
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: params);
    return uri.toString();
  }

  // Альтернативный метод с WorldView слоем (часто работает лучше)
  static String buildWorldViewImageUrl({required String date}) {
    const baseUrl = 'https://gibs.earthdata.nasa.gov/wms/epsg4326/best/wms.cgi';
    
    final params = {
      'SERVICE': 'WMS',
      'VERSION': '1.1.1',
      'REQUEST': 'GetMap',
      'LAYERS': 'VIIRS_SNPP_CorrectedReflectance_TrueColor', // Альтернативный слой
      'SRS': 'EPSG:4326',
      'BBOX': '-180,-90,180,90',
      'WIDTH': '800',
      'HEIGHT': '600',
      'FORMAT': 'image/jpeg',
      'TIME': date,
      'TRANSPARENT': 'false',
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: params);
    return uri.toString();
  }

  // Функция для прямого получения изображения
  static Future<http.Response> getImage(String imageUrl) async {
    try {
      final response = await http.get(
        Uri.parse(imageUrl),
        headers: {
          'User-Agent': 'EarthImageryApp/1.0',
          'Referer': 'https://earthdata.nasa.gov' // Важно для NASA
        },
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Альтернативный API для тестирования
  static String getTestImageUrl() {
    return 'https://picsum.photos/800/600';
  }

  // EONET API для природных событий (альтернатива)
  static String getEonetEventsUrl() {
    return 'https://eonet.gsfc.nasa.gov/api/v3/events';
  }
}