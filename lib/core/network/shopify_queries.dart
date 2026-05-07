class ShopifyQueries {
  static const String getProducts = r'''
query GetProducts($first: Int!, $after: String, $query: String) {
  products(first: $first, after: $after, query: $query) {
    edges {
      cursor
      node {
        id
        title
        handle
        description
        priceRange { minVariantPrice { amount currencyCode } }
        images(first: 1) { edges { node { url altText } } }
        variants(first: 10) { edges { node { id title price { amount } availableForSale } } }
      }
    }
    pageInfo { hasNextPage endCursor }
  }
}
''';

  static const String getProductById = r'''
query GetProductById($id: ID!) {
  product(id: $id) {
    id
    title
    handle
    description
    descriptionHtml
    totalInventory
    tags
    vendor
    priceRange { minVariantPrice { amount currencyCode } }
    images(first: 10) { edges { node { url altText } } }
    variants(first: 10) { edges { node { id title price { amount } availableForSale } } }
  }
}
''';

  static const String getCollections = r'''
query GetCollections($first: Int!) {
  collections(first: $first) { edges { node { id title handle image { url altText } description } } }
}
''';

  static const String getCollectionProducts = r'''
query GetCollectionProducts($handle: String!, $first: Int!, $after: String) {
  collection(handle: $handle) {
    products(first: $first, after: $after) {
      edges {
        cursor
        node {
          id
          title
          handle
          description
          priceRange { minVariantPrice { amount currencyCode } }
          images(first: 1) { edges { node { url altText } } }
          variants(first: 10) { edges { node { id title price { amount } availableForSale } } }
        }
      }
      pageInfo { hasNextPage endCursor }
    }
  }
}
''';

  /// Storefront API: creates a cart and returns [checkoutUrl] for WebView checkout.
  static const String cartCreate = r'''
mutation cartCreate($input: CartInput!) {
  cartCreate(input: $input) {
    cart {
      id
      checkoutUrl
    }
    userErrors {
      field
      message
    }
  }
}
''';
  static const String cartAddLines =
      r'''mutation CartAddLines($cartId: ID!, $lines: [CartLineInput!]!) {
  cartLinesAdd(cartId: $cartId, lines: $lines) {
    cart { id checkoutUrl lines(first: 100) { edges { node { id quantity merchandise { ... on ProductVariant { id title product { title images(first:1) { edges { node { url } } } } price { amount } } } } } } cost { totalAmount { amount currencyCode } } }
    cartUserErrors { message }
  }
}''';
  static const String cartUpdateLines =
      r'''mutation CartUpdateLines($cartId: ID!, $lineId: ID!, $quantity: Int!) {
  cartLinesUpdate(cartId: $cartId, lines: [{id: $lineId, quantity: $quantity}]) {
    cart { id checkoutUrl lines(first: 100) { edges { node { id quantity merchandise { ... on ProductVariant { id title product { title images(first:1) { edges { node { url } } } } price { amount } } } } } } cost { totalAmount { amount currencyCode } } }
    cartUserErrors { message }
  }
}''';
  static const String cartRemoveLines =
      r'''mutation CartRemoveLines($cartId: ID!, $lineIds: [ID!]!) {
  cartLinesRemove(cartId: $cartId, lineIds: $lineIds) {
    cart { id checkoutUrl lines(first: 100) { edges { node { id quantity merchandise { ... on ProductVariant { id title product { title images(first:1) { edges { node { url } } } } price { amount } } } } } } cost { totalAmount { amount currencyCode } } }
    cartUserErrors { message }
  }
}''';
  static const String getCart = r'''query GetCart($cartId: ID!) {
  cart(id: $cartId) {
    id
    checkoutUrl
    lines(first: 100) { edges { node { id quantity merchandise { ... on ProductVariant { id title product { title images(first:1) { edges { node { url } } } } price { amount } } } } } }
    cost { totalAmount { amount currencyCode } }
  }
}''';
}
