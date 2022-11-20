import 'dart:io';

import 'package:dotenv_masterclass/src/errors/not_found_error.dart';
import 'package:dotenv_masterclass/src/errors/not_initializer_error.dart';
import 'package:dotenv_masterclass/src/models/dotenv_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dotenv', () {
    group('isValidExtensionFile', () {
      test('should return true when file has a valid extension', () {
        final dotEnv = DotEnvModel(filePath: '.env');
        final result = dotEnv.isValidExtensionFile();
        expect(result, isTrue);
      });

      test('should return false when file has a invalid extension', () {
        final dotEnv = DotEnvModel(filePath: 'development.txt');
        final result = dotEnv.isValidExtensionFile();
        expect(result, isFalse);
      });
    });

    group('createEnvVars', () {
      test('should return a string when value exists in file', () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(dotEnv.getValue('ola'), 'mundo');
      });

      test('should throws an exception when file not exists', () async {
        final dotEnv = DotEnvModel(filePath: '.en');

        expect(
          () async => await dotEnv.load(),
          throwsA(isA<FileSystemException>()),
        );

        expect(
          () async => await dotEnv.load(),
          throwsA(const FileSystemException('File Not Found')),
        );
      });

      test('should throws an exception when is not .env file', () async {
        final dotEnv = DotEnvModel(filePath: 'development.txt');

        expect(
          () async => dotEnv.load(),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('getValue', () {
      test('should return a string when key exists in file', () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(dotEnv.getValue('ola'), 'mundo');
      });

      test(
          'should return an empty string when key exists in file and has no value',
          () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(dotEnv.getValue('eba'), isEmpty);
      });

      test(
          'should return an empty string when key exists in file and value is commented',
          () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(dotEnv.getValue('comentario'), isEmpty);
      });

      test('should throws an exception when line is commented', () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(() => dotEnv.getValue('com'), throwsException);

        expect(
          () => dotEnv.getValue('com'),
          throwsA(isInstanceOf<NotFoundError>()),
        );
      });
      test('should throws an exception when file was not loaded', () async {
        final dotEnv = DotEnvModel(filePath: '.env');

        expect(() => dotEnv.getValue('ola'), throwsException);

        expect(
          () => dotEnv.getValue('ola'),
          throwsA(isInstanceOf<NotInitializedError>()),
        );
      });

      test('should throws an exception when key not found', () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(() => dotEnv.getValue('yep'), throwsException);

        expect(
          () => dotEnv.getValue('yep'),
          throwsA(isInstanceOf<NotFoundError>()),
        );
      });
    });

    group('getValueAsInteger', () {
      test('should return an integer when parse works', () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(dotEnv.getValueAsInteger('numero'), 1);
      });

      test('should return null when parse fails', () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(dotEnv.getValueAsInteger('ola'), null);
      });

      test('should throws an exception when file was not loaded', () async {
        final dotEnv = DotEnvModel(filePath: '.env');

        expect(() => dotEnv.getValueAsInteger('numero'), throwsException);

        expect(
          () => dotEnv.getValueAsInteger('numero'),
          throwsA(isInstanceOf<NotInitializedError>()),
        );
      });

      test('should throws an exception when key not found', () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(() => dotEnv.getValueAsInteger('yep'), throwsException);

        expect(
          () => dotEnv.getValueAsInteger('yep'),
          throwsA(isInstanceOf<NotFoundError>()),
        );
      });
    });

    group('getValueAsDouble', () {
      test('should return an double when parse works', () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(dotEnv.getValueAsDouble('numeroDouble'), 2.0);
      });

      test('should return null when parse fails', () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(dotEnv.getValueAsDouble('ola'), null);
      });

      test('should throws an exception when file was not loaded', () async {
        final dotEnv = DotEnvModel(filePath: '.env');

        expect(() => dotEnv.getValueAsDouble('numeroDouble'), throwsException);

        expect(
          () => dotEnv.getValueAsDouble('numeroDouble'),
          throwsA(isInstanceOf<NotInitializedError>()),
        );
      });

      test('should throws an exception when key not found', () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(() => dotEnv.getValueAsDouble('yep'), throwsException);

        expect(
          () => dotEnv.getValueAsDouble('yep'),
          throwsA(isInstanceOf<NotFoundError>()),
        );
      });
    });

    group('getValueAsBool', () {
      test('should return an double when parse works', () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(dotEnv.getValueAsBool('verdadeiro'), isTrue);
      });

      test('should return false when parse works and value is false', () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(dotEnv.getValueAsBool('falso'), isFalse);
      });

      test('should return false when parse works and value is a string',
          () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(dotEnv.getValueAsBool('ola'), isFalse);
      });

      test('should throws an exception when file was not loaded', () async {
        final dotEnv = DotEnvModel(filePath: '.env');

        expect(() => dotEnv.getValueAsBool('verdadeiro'), throwsException);

        expect(
          () => dotEnv.getValueAsBool('verdadeiro'),
          throwsA(isInstanceOf<NotInitializedError>()),
        );
      });

      test('should throws an exception when key not found', () async {
        final dotEnv = DotEnvModel(filePath: '.env');
        await dotEnv.load();
        expect(() => dotEnv.getValueAsBool('yep'), throwsException);

        expect(
          () => dotEnv.getValueAsBool('yep'),
          throwsA(isInstanceOf<NotFoundError>()),
        );
      });
    });
  });
}
