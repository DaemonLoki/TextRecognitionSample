//
//  ContentView.swift
//  Text Recognition Sample
//
//  Created by Stefan Blos on 25.05.20.
//  Copyright © 2020 Stefan Blos. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?

    var body: some View {
        ZStack {
            Rectangle().fill(Color.secondary)

            if image != nil {
                image?.resizable().scaledToFit()
            } else {
                Text("Tap to select a picture").foregroundColor(.white).font(.headline)
            }
        }.onTapGesture {
            self.showingImagePicker = true
        }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





