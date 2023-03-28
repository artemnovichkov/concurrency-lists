//
//  Created by Artem Novichkov on 27.02.2023.
//

import SwiftUI

struct MainView: View {

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                NavigationLink(destination: DetailsView()) {
                    Text("Open ContentView")
                }
                NavigationLink(destination: ProductsView()) {
                    Text("Open ProductsView")
                }
            }
        }
        .navigationTitle("Main View")
    }
}
