//
//  ImageCarousel.swift
//  
//
//  Created by Davis Allie on 23/6/2023.
//

import SwiftUI

struct ImageCarousel: View {
    
    var urls: [URL] = []
    
    @State private var currentURL: URL?
    
    var body: some View {
        TabView(selection: $currentURL) {
            ForEach(urls, id: \.self) { url in
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        Color.clear
                            .overlay {
                                image
                                    .resizable()
                                    .scaledToFit()
                            }
                            .clipped()
                    case .failure(let error):
                        Text(error.localizedDescription)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        Text("Unknown")
                    }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct ImageCarousel_Previews: PreviewProvider {
    
    static var previews: some View {
        ImageCarousel(
            urls: [
                "https://media.soundtrails.com.au/soundtrails/40160ede-a6b7-4817-9846-f161f7a7f4b3/a696e663-f65b-5878-ab05-4b59133ff5b4.jpeg",
                "https://media.soundtrails.com.au/soundtrails/40160ede-a6b7-4817-9846-f161f7a7f4b3/8e93b995-c4ff-56d4-9c38-5b9ead5ded6b.jpeg",
                "https://media.soundtrails.com.au/soundtrails/40160ede-a6b7-4817-9846-f161f7a7f4b3/91fa31bd-4703-535e-a30c-cd9bf0966ea5.jpeg",
                "https://media.soundtrails.com.au/soundtrails/40160ede-a6b7-4817-9846-f161f7a7f4b3/36e98c55-a5e3-52bc-9669-f78c1fd58c91.jpeg",
                "https://media.soundtrails.com.au/soundtrails/40160ede-a6b7-4817-9846-f161f7a7f4b3/c5618206-3f4f-5045-bf6e-29f0a8df118b.jpeg"
            ].compactMap { URL(string: $0) }
        )
    }
}
