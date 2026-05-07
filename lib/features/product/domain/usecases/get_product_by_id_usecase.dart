import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductByIdUseCase {
  GetProductByIdUseCase(this.repository);

  final ProductRepository repository;

  Future<Either<Failure, ProductEntity>> call(String id) {
    return repository.getProductById(id);
  }
}
