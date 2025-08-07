import 'package:flutter_test/flutter_test.dart';
import 'package:ecom/features/auth/domain/entities/user.dart';

void main() {
  group('User Entity', () {
    const user1 = User(
      id: '1',
      name: 'Sabona',
      email: 'sabona@example.com',
      token: 'abc123',
    );

    const user2 = User(
      id: '1',
      name: 'Sabona',
      email: 'sabona@example.com',
      token: 'abc123',
    );

    const differentUser = User(
      id: '2',
      name: 'Waktole',
      email: 'waktole@example.com',
      token: 'xyz456',
    );

    test('should support value equality', () {
      expect(user1, equals(user2));
    });

    test('should not be equal if any field differs', () {
      expect(user1 == differentUser, isFalse);
    });

    test('should have correct props for Equatable', () {
      expect(user1.props, ['1', 'Sabona', 'sabona@example.com', 'abc123']);
    });
  });
}
