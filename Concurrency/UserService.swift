//
//  Created by Artem Novichkov on 27.02.2023.
//

import Foundation

class UserService {

    static let shared: UserService = .init()

    func getUser(completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success(User()))
        }
    }
}

extension UserService {

    func getUser() async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            getUser { result in
                continuation.resume(with: result)
            }
        }
    }
}

struct User {

    var name = "Artem"
}
