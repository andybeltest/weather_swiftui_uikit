//
//  HomeWeatherView.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var model: WeatherViewModel
    
    var body: some View {
        VStack {
            if let city = model.city {
                Text(city)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
            }
            if let temp = model.temp {
                Text(temp)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
            }
        }
    }
}

#if DEBUG
struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WeatherView(model: WeatherViewModel(
                city: "San Francisco",
                temp: "60 F"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
    }
}
#endif
