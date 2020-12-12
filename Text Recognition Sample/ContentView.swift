//
//  ContentView.swift
//  Text Recognition Sample
//
//  Created by Stefan Blos on 25.05.20.
//  Copyright © 2020 Stefan Blos. All rights reserved.
//

import SwiftUI
import Vision

struct ContentView: View {
    @State private var showingImagePicker = false
    @State private var image: Image?
    @State private var textFromImage: String?
    @State private var inputImage: UIImage?

    var body: some View {
        ZStack {
            Rectangle().fill(Color.secondary)

            if textFromImage != nil {
                Text(textFromImage ?? "shit").foregroundColor(.white).font(.headline)
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
        guard let inputImage = inputImage else {
            return
        }
        var ciImage = CIImage(image: inputImage)!
        var cgImage = convertCIImageToCGImage(inputImage: ciImage)
        textFromImage = recognizeText(from: cgImage!)
        image = Image(uiImage: inputImage)
    }

    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        if context != nil {
            return context.createCGImage(inputImage, from: inputImage.extent)
        }
        return nil
    }

    func recognizeText(from image: CGImage) -> String {
        var entireRecognizedText = ""
        let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
            guard error == nil else {
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }

            let maximumRecognitionCandidates = 1
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumRecognitionCandidates).first else {
                    continue
                }

                entireRecognizedText += "\(candidate.string)\n"

            }
        }
        recognizeTextRequest.recognitionLevel = .accurate

        let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])

        try? requestHandler.perform([recognizeTextRequest])

        return entireRecognizedText
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





