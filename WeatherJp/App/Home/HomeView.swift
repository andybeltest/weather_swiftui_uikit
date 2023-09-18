//
//  HomeView.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var isSearching = false
    @State private var selectedSearchItem: SearchItem?
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination:
                    SearchViewRepresentable(
                        container: viewModel.container,
                        delegate: viewModel).navigationBarHidden(true),
                               isActive: $isSearching) {
                    EmptyView()
                }
                
                HStack {
                    Button(action: {
                        isSearching = true
                    }) {
                        Text("\(Image(systemName: "magnifyingglass")) Search...")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 18))
                            .padding()
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .background(Color.clear)
                    .cornerRadius(25)
                    
                    Button(action: {
                        viewModel.requestLocation()
                    }) {
                        if viewModel.isRequestingLocation {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("\(Image(systemName: "location"))")
                                .foregroundColor(.white)
                        }
                    }.padding()
                }
                
                if viewModel.isFetching {
                    ProgressView()
                        .tint(.white)
                        .padding()
                } else {
                    WeatherView(model: viewModel.weather)
                }
                
                Spacer()
            }
            .padding()
            .background(.blue)
        }.navigationViewStyle(StackNavigationViewStyle()).navigationBarTitleDisplayMode(.inline)
    }
}



#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(container: debugContainer))
    }
}
#endif
