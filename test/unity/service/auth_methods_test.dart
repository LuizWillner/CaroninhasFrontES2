import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';

import 'auth_services_test.mocks.dart';

void main() {
  late AuthService authService;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    authService = AuthService(apiService: mockApiService);
  });

  group('AuthService', () {
    test('login returns response from apiService', () async {
      final response = {'token': 'abc123'};
      when(mockApiService.postUrlencoded(any, any))
          .thenAnswer((_) async => response);

      final result = await authService.login('username', 'password');

      expect(result, response);
      verify(mockApiService.postUrlencoded('token', {
        'username': 'username',
        'password': 'password',
      })).called(1);
    });

    test('createUser returns response from apiService', () async {
      final response = {'id': 1};
      when(mockApiService.postApi(any, any)).thenAnswer((_) async => response);

      final result = await authService.createUser(
        'email@example.com',
        'First',
        'Last',
        '12345678900',
        '2000-05-20T04:48:56.242Z',
        'iduff',
        '123456789',
        'password',
      );

      expect(result, response);
      verify(mockApiService.postApi('users/create', {
        'email': 'email@example.com',
        'first_name': 'First',
        'last_name': 'Last',
        'cpf': '12345678900',
        'birthdate': '2000-05-20T04:48:56.242Z',
        'phone': '123456789',
        'iduff': 'iduff',
        'password': 'password',
      })).called(1);
    });

    test('createCar returns response from apiService', () async {
      final response = {'id': 1};
      when(mockApiService.postApi(any, any)).thenAnswer((_) async => response);

      final result = await authService.createCar('Toyota', 'Corolla', 'Red', 'XYZ-1234');

      expect(result, response);
      verify(mockApiService.postApi(
        'veiculo/me?tipo=CARRO&marca=Toyota&modelo=Corolla&cor=Red&placa=XYZ-1234',
        {},
      )).called(1);
    });

    test('createRide returns response from apiService', () async {
      final response = {'id': 1};
      when(mockApiService.postApi(any, any)).thenAnswer((_) async => response);

      final result = await authService.createRide(
        1,
        DateTime.parse('2023-06-01T10:00:00.000Z'),
        '20.00',
        '3',
        'Point A',
        'Point B',
      );

      final encodedHoraDePartida = Uri.encodeComponent('2023-06-01T10:00:00.000Z');

      expect(result, response);
      verify(mockApiService.postApi(
        'carona?veiculo_id=1&hora_de_partida=$encodedHoraDePartida&preco_carona=20.00&vagas=3',
        {'local_partida': 'Point A', 'local_destino': 'Point B'},
      )).called(1);
    });

    test('becomeMotorist returns response from apiService', () async {
      final response = {'status': 'success'};
      when(mockApiService.postApi(any, any)).thenAnswer((_) async => response);

      final result = await authService.becomeMotorist('12345678900');

      expect(result, response);
      verify(mockApiService.postApi(
        'users/me/motorista?num_cnh=12345678900',
        {},
      )).called(1);
    });
  });
}
