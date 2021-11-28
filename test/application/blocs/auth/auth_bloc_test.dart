import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:telleo/application/blocs/auth/auth_bloc.dart';
import 'package:telleo/domain/auth/auth_failure.dart';
import 'package:telleo/domain/auth/auth_repository.dart';
import 'package:telleo/domain/auth/value_objects.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('AuthBloc', () {
    late AuthBloc bloc;
    late MockAuthRepository authRepository;
    setUp(() {
      authRepository = MockAuthRepository();
      bloc = AuthBloc(authRepository);
    });
    final AuthState initialState = AuthState(
      obscurePassword: false,
      emailAdress: EmailAdress(''),
      password: Password(''),
      isSubmitting: false,
      authFailureOrSuccess: none(),
      showErrorMessages: false,
    );
    test('initial state should be as constructed as in the test', () {
      expect(bloc.state, equals(initialState));
    });

    tearDown(() async {
      await bloc.close();
    });
    group('PasswordChanged', () {
      test(
          'When PasswordChanged is emitted password should contain the password (can be in the failure)',
          () async {
        const password = 'hello';

        expectLater(bloc.stream,
            emits(AuthState.initial().copyWith(password: Password(password))));
        bloc.add(const AuthEvent.passwordChanged(password));
      });
    });

    group('EmailChanged', () {
      test(
          'When EmailChanged is emitted email should contain the email (can be in the failure)',
          () async {
        const email = 'ze@songij.fr';

        expectLater(
            bloc.stream,
            emits(
                AuthState.initial().copyWith(emailAdress: EmailAdress(email))));
        bloc.add(const AuthEvent.emailChanged(email));
      });
    });

    group('SignIn', () {
      test(
          'When SignIn is emitted and both the password and the email are valid authRepository.signInWithEmailAndPassword should be called, when that returns a unit signin was successful',
          () async {
        const email = 'ze@songij.fr';
        const password = 'URQfGnKkpfoaonssbaUq';
        final initial = AuthState.initial().copyWith(
            password: Password(password), emailAdress: EmailAdress(email));
        bloc = AuthBloc(authRepository, initial);

        when(authRepository.signInWithEmailAndPassword(
                email: anyNamed('email'), password: anyNamed('password')))
            .thenAnswer((_) async => right(unit));

        expectLater(
            bloc.stream,
            emitsInOrder([
              initial.copyWith(
                authFailureOrSuccess: none(),
                isSubmitting: true,
                showErrorMessages: false,
              ),
              initial.copyWith(
                authFailureOrSuccess: some(right(unit)),
                isSubmitting: false,
                showErrorMessages: false,
              ),
            ]));
        bloc.add(const AuthEvent.signIn());
        await untilCalled(authRepository.signInWithEmailAndPassword(
            email: anyNamed('email'), password: anyNamed('password')));
        verify(authRepository.signInWithEmailAndPassword(
                email: email, password: password))
            .called(1);
      });

      test(
          'When SignIn is emitted and either the password or the email are invalid authRepository.signInWithEmailAndPassword should not be called',
          () async {
        const email = 'zesongij.fr';
        const password = 'URQfG';
        final initial = AuthState.initial().copyWith(
            password: Password(password), emailAdress: EmailAdress(email));
        bloc = AuthBloc(authRepository, initial);

        when(authRepository.signInWithEmailAndPassword(
                email: anyNamed('email'), password: anyNamed('password')))
            .thenAnswer((_) async => right(unit));

        expectLater(
            bloc.stream,
            emitsInOrder([
              initial.copyWith(
                authFailureOrSuccess: none(),
                isSubmitting: true,
                showErrorMessages: false,
              ),
              initial.copyWith(
                authFailureOrSuccess: none(),
                isSubmitting: false,
                showErrorMessages: true,
              ),
            ]));
        bloc.add(const AuthEvent.signIn());
        verifyNever(authRepository.signInWithEmailAndPassword(
            email: email, password: password));
      });

      test(
          'When SignIn is emitted and both the password and the email are valid authRepository.signInWithEmailAndPassword should be called, when that returns an auth failure signin was not successful',
          () async {
        const email = 'ze@songij.fr';
        const password = 'URQfGnKkpfoaonssbaUq';
        final initial = AuthState.initial().copyWith(
            password: Password(password), emailAdress: EmailAdress(email));
        bloc = AuthBloc(authRepository, initial);
        const authFailure = AuthFailure.cancelledByUser();

        when(authRepository.signInWithEmailAndPassword(
                email: anyNamed('email'), password: anyNamed('password')))
            .thenAnswer((_) async => left(authFailure));

        expectLater(
            bloc.stream,
            emitsInOrder([
              initial.copyWith(
                authFailureOrSuccess: none(),
                isSubmitting: true,
                showErrorMessages: false,
              ),
              initial.copyWith(
                authFailureOrSuccess: some(left(authFailure)),
                isSubmitting: false,
                showErrorMessages: true,
              ),
            ]));
        bloc.add(const AuthEvent.signIn());
        await untilCalled(authRepository.signInWithEmailAndPassword(
            email: anyNamed('email'), password: anyNamed('password')));
        verify(authRepository.signInWithEmailAndPassword(
                email: email, password: password))
            .called(1);
      });
    });

    group('SignUp', () {
      test(
          'When SignUp is emitted and both the password and the email are valid authRepository.signUpWithEmailAndPassword should be called, when that returns a unit signin was successful',
          () async {
        const email = 'ze@songij.fr';
        const password = 'URQfGnKkpfoaonssbaUq';
        final initial = AuthState.initial().copyWith(
            password: Password(password), emailAdress: EmailAdress(email));
        bloc = AuthBloc(authRepository, initial);

        when(authRepository.signUpWithEmailAndPassword(
                email: anyNamed('email'), password: anyNamed('password')))
            .thenAnswer((_) async => right(unit));

        expectLater(
            bloc.stream,
            emitsInOrder([
              initial.copyWith(
                authFailureOrSuccess: none(),
                isSubmitting: true,
                showErrorMessages: false,
              ),
              initial.copyWith(
                authFailureOrSuccess: some(right(unit)),
                isSubmitting: false,
                showErrorMessages: false,
              ),
            ]));
        bloc.add(const AuthEvent.signUp());
        await untilCalled(authRepository.signUpWithEmailAndPassword(
            email: anyNamed('email'), password: anyNamed('password')));
        verify(authRepository.signUpWithEmailAndPassword(
                email: email, password: password))
            .called(1);
      });

      test(
          'When SignUp is emitted and either the password or the email are invalid authRepository.signUpWithEmailAndPassword should not be called',
          () async {
        const email = 'zesongij.fr';
        const password = 'URQfG';
        final initial = AuthState.initial().copyWith(
            password: Password(password), emailAdress: EmailAdress(email));
        bloc = AuthBloc(authRepository, initial);

        when(authRepository.signUpWithEmailAndPassword(
                email: anyNamed('email'), password: anyNamed('password')))
            .thenAnswer((_) async => right(unit));

        expectLater(
            bloc.stream,
            emitsInOrder([
              initial.copyWith(
                authFailureOrSuccess: none(),
                isSubmitting: true,
                showErrorMessages: false,
              ),
              initial.copyWith(
                authFailureOrSuccess: none(),
                isSubmitting: false,
                showErrorMessages: true,
              ),
            ]));
        bloc.add(const AuthEvent.signUp());
        verifyNever(authRepository.signUpWithEmailAndPassword(
            email: email, password: password));
      });

      test(
          'When SignUp is emitted and both the password and the email are valid authRepository.signUpWithEmailAndPassword should be called, when that returns an auth failure SignUp was not successful',
          () async {
        const email = 'ze@songij.fr';
        const password = 'URQfGnKkpfoaonssbaUq';
        final initial = AuthState.initial().copyWith(
            password: Password(password), emailAdress: EmailAdress(email));
        bloc = AuthBloc(authRepository, initial);
        const authFailure = AuthFailure.cancelledByUser();

        when(authRepository.signUpWithEmailAndPassword(
                email: anyNamed('email'), password: anyNamed('password')))
            .thenAnswer((_) async => left(authFailure));

        expectLater(
            bloc.stream,
            emitsInOrder([
              initial.copyWith(
                authFailureOrSuccess: none(),
                isSubmitting: true,
                showErrorMessages: false,
              ),
              initial.copyWith(
                authFailureOrSuccess: some(left(authFailure)),
                isSubmitting: false,
                showErrorMessages: true,
              ),
            ]));
        bloc.add(const AuthEvent.signUp());
        await untilCalled(authRepository.signUpWithEmailAndPassword(
            email: anyNamed('email'), password: anyNamed('password')));
        verify(authRepository.signUpWithEmailAndPassword(
                email: email, password: password))
            .called(1);
      });
    });

    group('SignInWithGoogle', () {
      test(
          'When SignInGoogle is called authRepository.signInWithGoogle should be called, when that returns a unit signin was successful',
          () async {
        const email = 'ze@songij.fr';
        const password = 'URQfGnKkpfoaonssbaUq';

        when(authRepository.signInWithGoogle())
            .thenAnswer((_) async => right(unit));

        expectLater(
            bloc.stream,
            emitsInOrder([
              initialState.copyWith(
                authFailureOrSuccess: none(),
                isSubmitting: true,
                showErrorMessages: false,
              ),
              initialState.copyWith(
                authFailureOrSuccess: some(right(unit)),
                isSubmitting: false,
                showErrorMessages: false,
              ),
            ]));
        bloc.add(const AuthEvent.signInWithGoogle());
        await untilCalled(authRepository.signInWithGoogle());
        verify(authRepository.signInWithGoogle()).called(1);
      });

      test(
          'When SignInWithGoogle is emitted authRepository.signInWithGoogle should be called, when that returns an auth failure SignUp was not successful',
          () async {
        const email = 'ze@songij.fr';
        const password = 'URQfGnKkpfoaonssbaUq';
        final initial = initialState;
        const authFailure = AuthFailure.cancelledByUser();

        when(authRepository.signInWithGoogle())
            .thenAnswer((_) async => left(authFailure));

        expectLater(
            bloc.stream,
            emitsInOrder([
              initial.copyWith(
                authFailureOrSuccess: none(),
                isSubmitting: true,
                showErrorMessages: false,
              ),
              initial.copyWith(
                authFailureOrSuccess: some(left(authFailure)),
                isSubmitting: false,
                showErrorMessages: true,
              ),
            ]));
        bloc.add(const AuthEvent.signInWithGoogle());
        await untilCalled(authRepository.signInWithGoogle());
        verify(authRepository.signInWithGoogle()).called(1);
      });
    });
  });
}
