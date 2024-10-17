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
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            KFImage(imageURL)
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width * scale, height: geometry.size.height * scale)
                .offset(x: offset.width, y: offset.height)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / lastScaleValue
                                lastScaleValue = value
                                let newScale = scale * delta
                                
                                // Prevent scaling below original size
                                if newScale >= 1.0 {
                                    scale = newScale
                                    
                                    // Recompute offset to keep the image centered
                                    let maxOffsetX = (geometry.size.width * scale - geometry.size.width) / 2
                                    let maxOffsetY = (geometry.size.height * scale - geometry.size.height) / 2
                                    
                                    offset = CGSize(
                                        width: min(max(offset.width, -maxOffsetX), maxOffsetX),
                                        height: min(max(offset.height, -maxOffsetY), maxOffsetY)
                                    )
                                }
                            }
                            .onEnded { _ in
                                lastScaleValue = 1.0
                            },
                        DragGesture()
                            .onChanged { value in
                                // Update the offset based on drag translation
                                var newOffset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                                
                                // Constrain the image movement within the bounds when zoomed in
                                let maxOffsetX = (geometry.size.width * scale - geometry.size.width) / 2
                                let maxOffsetY = (geometry.size.height * scale - geometry.size.height) / 2
                                
                                newOffset.width = max(-maxOffsetX, min(maxOffsetX, newOffset.width))
                                newOffset.height = max(-maxOffsetY, min(maxOffsetY, newOffset.height))
                                
                                offset = newOffset
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            }
                    )
                )
                .onTapGesture {
                    // Reset scaling and offset on tap
                    withAnimation {
                        scale = 1.0
                        offset = .zero
                        lastOffset = .zero
                    }
                }
        }
        .background(Color.black.ignoresSafeArea())
    }
}
