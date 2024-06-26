//
//  WeatherIconView.swift
//  WeatherApp
//
//  Created by Pawan on 26/06/24.
//

import SwiftUI

struct WeatherIconView: View {
	var body: some View {
		AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) { image in
			image
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 350)
		} placeholder: {
			ProgressView()
		}
	}
}
