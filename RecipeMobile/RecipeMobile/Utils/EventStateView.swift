//
//  EventStateView.swift
//  RecipeMobile
//
//  Created by Oscar Castillo on 17/10/24.
//

import SwiftUI

struct EventStateView: View {
    
    let text: String
    let imageName: String
    
    var body: some View {
        
        VStack(alignment: .center) {
            Spacer()
            Text(text)
                .font(.title3)
                .foregroundStyle(.primary)
                .padding(.vertical)
            
            Image(systemName: imageName)
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
        }
        .padding()
        
    }
}
