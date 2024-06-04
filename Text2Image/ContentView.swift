//
//  ContentView.swift
//  Text2Image
//
//  Created by Chima onyekwere on 5/29/24.
//

import SwiftUI

struct ContentView: View {
    @State private var newImage: UIImage? = nil
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing:30) {
                if let newImage = newImage {
                    Image(uiImage: newImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:350, height: 900)
                } else {
                    Text("Generating image...")
                }
                
                ImageWithTextOverlayView(text: "Hello my name is chima", imageName: "smile", point: CGPoint(x:90, y: 20))
                    .frame(width: 0, height: 600)


            }
            .padding()
        .scrollTargetLayout()
        }
      .scrollTargetBehavior(.viewAligned)
        //.safeAreaPadding(.horizontal, 40)
    }
}





#Preview {
    ContentView()
}
