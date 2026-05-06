import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopify_supabase_store/core/error/failures.dart';
import 'package:shopify_supabase_store/features/product/domain/entities/product_entity.dart';
import 'package:shopify_supabase_store/features/product/domain/repositories/product_repository.dart';
import 'package:shopify_supabase_store/features/product/domain/usecases/get_products_usecase.dart';

class _MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late _MockProductRepository repository;
  late GetProductsUseCase useCase;

  setUp(() {
    repository = _MockProductRepository();
    useCase = GetProductsUseCase(repository);
  });

  test('returns product list on success', () async {
    when(
      () => repository.getProducts(
          cursor: any(named: 'cursor'),
          query: any(named: 'query'),
          first: any(named: 'first')),
    ).thenAnswer((_) async => const Right((<ProductEntity>[], false, null)));

    final result = await useCase();
    expect(result.isRight(), true);
  });

  test('returns ServerFailure on API error', () async {
    when(
      () => repository.getProducts(
          cursor: any(named: 'cursor'),
          query: any(named: 'query'),
          first: any(named: 'first')),
    ).thenAnswer((_) async => const Left(ServerFailure('Server error')));

    final result = await useCase();
    expect(result, const Left(ServerFailure('Server error')));
  });
}
