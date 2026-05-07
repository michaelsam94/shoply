import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  GetProductsUseCase(this.repository);
  final ProductRepository repository;

  Future<
          Either<Failure,
              (List<ProductEntity> products, bool hasNextPage, String? cursor)>>
      call({
    String? cursor,
    String? query,
    int first = 20,
  }) {
    return repository.getProducts(cursor: cursor, query: query, first: first);
  }
}
