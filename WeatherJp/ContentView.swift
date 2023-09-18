//
//  ContentView.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import SwiftUI
import Swinject

struct ContentView: View {
    let container: Container
    
    var body: some View {
        HomeView(viewModel: HomeViewModel(container: container))
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(container: debugContainer)
    }
}
#endif
