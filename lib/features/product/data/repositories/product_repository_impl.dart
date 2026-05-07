import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/shopify_product_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._datasource);

  final ShopifyProductDatasource _datasource;

  @override
  Future<
          Either<Failure,
              (List<ProductEntity> products, bool hasNextPage, String? cursor)>>
      getProducts({
    String? cursor,
    String? query,
    int first = 20,
  }) async {
    try {
      final result = await _datasource.getProducts(
        cursor: cursor,
        query: query,
        first: first,
      );
      return Right((result.$1, result.$2, result.$3));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    try {
      return Right(await _datasource.getProductById(id));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CollectionEntity>>> getCollections() async {
    return const Right(<CollectionEntity>[]);
  }
}
