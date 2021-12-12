import 'package:dartz/dartz.dart';

import '../core/value_objects.dart';
import '../user/user_entity.dart';
import 'auth_failure.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, UserEntity>> signUpWithEmailAndPassword({
    required EmailAdress email,
    required Password password,
  });
  Future<Either<AuthFailure, UserEntity>> signInWithEmailAndPassword({
    required EmailAdress email,
    required Password password,
  });

  Future<Either<AuthFailure, UserEntity>> signInWithGoogle();
}
