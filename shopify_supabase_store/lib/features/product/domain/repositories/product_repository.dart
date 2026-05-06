import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<
          Either<Failure,
              (List<ProductEntity> products, bool hasNextPage, String? cursor)>>
      getProducts({String? cursor, String? query, int first = 20});
  Future<Either<Failure, ProductEntity>> getProductById(String id);
  Future<Either<Failure, List<CollectionEntity>>> getCollections();
}
