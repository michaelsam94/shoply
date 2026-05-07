import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetCollectionsUseCase {
  GetCollectionsUseCase(this.repository);

  final ProductRepository repository;

  Future<Either<Failure, List<CollectionEntity>>> call() {
    return repository.getCollections();
  }
}
