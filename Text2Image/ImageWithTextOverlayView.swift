//
//  ImageWithTextOverlayView.swift
//  Text2Image
//
//  Created by Chima onyekwere on 5/29/24.
//

import SwiftUI

struct ImageWithTextOverlayView: UIViewRepresentable {
    var text: String
    var imageName: String
    var point: CGPoint

    func makeUIView(context: Context) -> UIImageView {
        return UIImageView()
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        if let image = UIImage(named: imageName) {
            let newImage = textToImage(drawText: text, inImage: image, atPoint: point)
            uiView.image = newImage
        }
    }
}


#Preview {
    ImageWithTextOverlayView(text: "Hello my name is chima", imageName: "smile", point: CGPoint(x:90, y: 20))
               .frame(width: 0, height: 0)
}
