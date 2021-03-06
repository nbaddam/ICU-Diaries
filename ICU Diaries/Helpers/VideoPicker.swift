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
    @Binding var sourceType: UIImagePickerController.SourceType

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: VideoPicker

        init(_ parent: VideoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                parent.videoUrl = url.absoluteString
                print("videoUrl in picker if:", parent.videoUrl)
                if (parent.sourceType == .savedPhotosAlbum) {
                    let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                    /// create a temporary file for us to copy the video to.
                    let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(url.lastPathComponent)
                    /// Attempt the copy.
                    do {
                        try FileManager().copyItem(at: url.absoluteURL, to: temporaryFileURL)
                    } catch {
                        print("There was an error copying the video file to the temporary location.")
                    }

                    parent.videoUrl =  temporaryFileURL.absoluteString
                }
                
//                if (parent.sourceType == .camera) {
//                    let selectorToCall = Selector()
//                    UISaveVideoAtPathToSavedPhotosAlbum(url.relativePath, self, selectorToCall, nil)
//                    var uuid = UUID().uuidString + ".mp4"
//                    let videoData = try? Data(contentsOf: url)
//                    let paths = NSSearchPathForDirectoriesInDomains(
//                                    FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//                    let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
//                    let dataPath = documentsDirectory.appendingPathComponent(uuid)
//                    try! videoData?.write(to: dataPath, options: [])
//                    parent.videoUrl = dataPath.absoluteString
//                }
            }
            do {
                
                let asset = AVURLAsset(url: URL(string: parent.videoUrl)! , options: nil)
//                print("videoUrl after picker if:", parent.videoUrl)
//                parent.videoUrl = asset.url.absoluteString
//                print("videoUrl after picker change:", parent.videoUrl)
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
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<VideoPicker>) {

    }
    
    
}


