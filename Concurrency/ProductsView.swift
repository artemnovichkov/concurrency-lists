//
//  Created by Artem Novichkov on 27.02.2023.
//

import SwiftUI
import Introspect

struct ProductsView: View {

    struct ProductsViewState: Equatable {

        let id: String
        let fromTop: Bool
    }

    let products: [Product] = [.init(name: "Постное меню"),
                               .init(name: "Суси и гунканы"),
                               .init(name: "Роллы"),
                               .init(name: "Сасими"),
                               .init(name: "Гунканы"),
                               .init(name: "Сеты"),
                               .init(name: "Закуски")]

    let colors: [Color] = [.random, .random, .random, .random, .random, .random, .random]

    @State private var productState: ProductsViewState?

    var body: some View {
        VStack {
            topSection
            bottomSection
        }
        .onAppear {
            productState = .init(id: products.first!.id, fromTop: true)
        }
    }

    private var topSection: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView(.horizontal) {
                HStack {
                    ForEach(products) { product in
                        Button(action: {
                            productState = .init(id: product.id, fromTop: true)
                        }, label: {
                            Text(product.name)
                                .font(product.name == productState?.id ? .largeTitle : .title)
                        })
                        .id(product.id)
                    }
                }
                .padding([.leading, .trailing])
                .onChange(of: productState) { productState in
                    if let productState {
                        withAnimation {
                            scrollViewProxy.scrollTo(productState.id, anchor: .center)
                        }
                    }
                }
            }
            .introspectScrollView { scrollView in
                scrollView.contentInset = .init(top: 0, left: 100, bottom: 0, right: 100)
            }
        }
    }

    private var bottomSection: some View {
        ScrollViewReader { scrollViewProxy in
            OffsetObservingScrollView(content: {
                VStack(spacing: 0) {
                    ForEach(0..<products.count) { index in
                        Text(products[index].name)
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .frame(height: 600)
                            .background(colors[index])
                            .id(products[index].id)
                    }
                }
            }, offsetHandler: { offset in
                if productState?.fromTop == false {
                    let index = Int(offset.y / 600)
                    productState = .init(id: products[index].id, fromTop: false)
                }
            })
            .simultaneousGesture(DragGesture()
                .onChanged({ _ in productState = .init(id: productState!.id, fromTop: false) }))
            .onChange(of: productState) { productState in
                if let productState {
                    withAnimation {
                        scrollViewProxy.scrollTo(productState.id, anchor: .top)
                    }
                }
            }
        }
    }

}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
