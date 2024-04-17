//
//  PageGallery.swift
//  NBAPal
//
//  Created by Roman Auersvald on 17.04.2024.
//

import SwiftUI

struct PageGallery: View {
    
    let images: [String]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { image in
                ZStack {
                    Color.gray
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                }
            }
        }.tabViewStyle(.page(indexDisplayMode: .always))
    }
}

#Preview {
    PageGallery(images: ["person.3.sequence.fill", "person.2.circle.fill", "figure.2"])
}
