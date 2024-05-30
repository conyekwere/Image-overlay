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
        VStack {
            if let newImage = newImage {
                Image(uiImage: newImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 200)
            } else {
                Text("Generating image...")
            }
            
            ImageWithTextOverlayView(text: "Hello my name is chima", imageName: "smile", point: CGPoint(x:90, y: 20))
                .frame(width: 0, height: 0)
        }
    }
}


#Preview {
    ContentView()
}
