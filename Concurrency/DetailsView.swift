//
//  Created by Artem Novichkov on 27.02.2023.
//

import SwiftUI

struct DetailsView: View {

    @StateObject var viewModel: DetailsViewModel = .init()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            else if let response = viewModel.response {
                Text("User: " + (response.user.name))
                Text("Products: \(response.products.count)")
            } else {
                Text("No response")
            }
        }
        .padding()
        .navigationTitle("Details View")
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

final class DetailsViewModel: ObservableObject {

    struct Response {
        
        let user: User
        let products: [Product]
    }

    private lazy var userService: UserService = .shared
    private lazy var productService: ProductService = .shared

    private var responseTask: Task<Void, Error>?
    @Published var isLoading = false
    @Published var response: Response?

    func onAppear() {
        let startDate = Date()
        isLoading = true
        responseTask = Task {
            let response = try await getSerialResponse()
            try Task.checkCancellation()
            await MainActor.run {
                self.response = response
                isLoading = false
                let endDate = Date()
                let timeInterval = endDate.timeIntervalSince(startDate)
                print("Time: \(timeInterval) seconds")
            }
        }
    }

    func onDisappear() {
        responseTask?.cancel()
    }

    private func getSerialResponse() async throws -> Response {
        let user = try await userService.getUser()
        let products = try await productService.getProducts()
        return Response(user: user, products: products)
    }

    private func getConcurrentResponse() async throws -> Response {
        async let user = userService.getUser()
        async let products = productService.getProducts()
        return try await Response(user: user, products: products)
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}
