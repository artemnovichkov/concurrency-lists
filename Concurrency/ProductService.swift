//
//  Created by Artem Novichkov on 27.02.2023.
//

import Foundation

class ProductService {

    static let shared: ProductService = .init()

    func getProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success([Product()]))
        }
    }
}

extension ProductService {

    func getProducts() async throws -> [Product] {
        try await withCheckedThrowingContinuation { continuation in
            getProducts { result in
                continuation.resume(with: result)
            }
        }
    }
}

struct Product: Identifiable {

    var name = "Product"

    var id: String {
        name
    }
}
