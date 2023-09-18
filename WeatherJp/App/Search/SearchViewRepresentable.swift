//
//  SearchViewRepresentable.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import SwiftUI
import Swinject

struct SearchViewRepresentable: UIViewControllerRepresentable {
    let container: Container
    var delegate: SearchViewControllerDelegate?

    func makeUIViewController(context: Context) -> SearchViewController {
        let viewModel = SearchViewModel(container: container)
        let controller = SearchViewController(viewModel: viewModel)
        controller.delegate = delegate
        return controller
    }
 
    func updateUIViewController(_ uiViewController: SearchViewController, context: Context) {
    }
    

    func makeCoordinator() -> SearchViewCoordinator {
        SearchViewCoordinator()
    }
}

class SearchViewCoordinator {
}
