//
//  FullScreenImageView.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import SwiftUI
import Kingfisher

struct FullScreenImageView: View {
    let imageURL: URL
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                KFImage(imageURL)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width)
                    .scaleEffect(scale)
                    .offset(x: offset.width, y: offset.height)
                    .gesture(MagnificationGesture()
                        .onChanged { value in
                            scale = value.magnitude
                        }
                        .onEnded { _ in
                            if scale < 1.0 {
                                scale = 1.0
                            }
                        }
                    )
                    .gesture(DragGesture()
                        .onChanged { value in
                            offset = value.translation
                        }
                        .onEnded { _ in
                            if scale == 1.0 {
                                offset = .zero
                            }
                        }
                    )
            }
        }
        .background(Color.black.ignoresSafeArea())
        .onTapGesture {
            scale = 1.0
            offset = .zero
        }
    }
}
