//
//  PhotoAlbumView.swift
//  MosaicGrid_Example
//
//  Created by Nayanda Haberty on 2/2/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI
import MosaicGrid

struct PhotoAlbumView: View {
    var body: some View {
        ScrollView(.vertical) {
            VMosaicGrid(hGridCount: 3, spacing: 2) {
                ForEach(0..<5) { _ in
                    image(from: "https://picsum.photos/200")
                        .usingGrids(h: 2, v: 2)
                    image(from: "https://picsum.photos/100")
                    image(from: "https://picsum.photos/100")
                    image(from: "https://picsum.photos/100/200")
                        .usingGrids(h: 1, v: 2)
                    image(from: "https://picsum.photos/100")
                    image(from: "https://picsum.photos/100")
                    image(from: "https://picsum.photos/200")
                        .usingGrids(h: 2, v: 2)
                    image(from: "https://picsum.photos/100")
                    image(from: "https://picsum.photos/100")
                    image(from: "https://picsum.photos/200/100")
                        .usingGrids(h: 2, v: 1)
                }
                
            }
        }
    }
    
    func image(from url: String) -> some View {
        AsyncImage(url: URL(string: url)) { image in
            image.resizable()
                .scaledToFit()
                .clipped()
        } placeholder: {
            Rectangle()
                .foregroundColor(.gray)
        }
        
    }
}

#Preview {
    PhotoAlbumView()
}
