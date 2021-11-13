//
//  VideoPicker.swift
//  ICU Diaries
//
//  Created by jacob kurian on 11/10/21.
//

import Foundation
import SwiftUI
import MobileCoreServices
import AVKit
import AVFoundation

struct VideoPicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var videoUrl: String
    @Binding var showVideoPicker: Bool
    @Binding var showActionSheetVideo: Bool
    @Binding var thumbnail: Image?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: VideoPicker

        init(_ parent: VideoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                parent.videoUrl = url.absoluteString
            }
            do {
                let asset = AVURLAsset(url: URL(string: parent.videoUrl)! , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                parent.thumbnail = Image(uiImage: thumbnail)
                } catch let error {
                    print("*** Error generating thumbnail: \(error.localizedDescription)")
                }
            parent.showVideoPicker = false
            parent.showActionSheetVideo = false
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<VideoPicker>) {

    }
    
    
}


