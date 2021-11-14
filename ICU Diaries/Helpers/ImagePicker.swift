//
//  ImagePicker.swift
//  ICU Diaries
//
//  Created by jacob kurian on 11/7/21.
//

import Foundation
import SwiftUI
import Photos

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: Image?
    @Binding var imageData: Data
    @Binding var showImagePicker: Bool
    @Binding var showActionSheetImage: Bool
    @Binding var imageUrl: String
    @Binding var sourceType: UIImagePickerController.SourceType
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
//
//        public func saveImgToLocal(_ img: UIImage) {
//            // significantly faster than creationRequestForAsset
//            UIImageWriteToSavedPhotosAlbum(img, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
//        }
//
//        @objc func imageSaved(_ img: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
//            if let error = error {
//                // we got back an error!
//                print("image didnt save")
//            } else {
//                let fetchOptions = PHFetchOptions()
//                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//                fetchOptions.fetchLimit = 1
//                let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
//                if let asset = fetchResult.firstObject
//                {
//                    print("calling get asset")
//                    getAsset(asset: asset)
//                }
//            }
//        }
//
//        func getAsset(asset: PHAsset) {
//            let manager = PHImageManager.default()
//            let option = PHImageRequestOptions()
//            let editOptions = PHContentEditingInputRequestOptions()
//            var hashString = "" as String
//            option.isSynchronous = true
//            asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (editingInput, info) in
//                if let input = editingInput, let imgUrl = input.fullSizeImageURL {
//                    self.parent.imageUrl = imgUrl.absoluteString
//                    print("imageUrl in get asset is: ", self.parent.imageUrl)
//                }
//            }
//            manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info) -> Void in
//
//                if let url = (info!["PHImageFileURLKey"] as? NSURL) {
//                    self.parent.imageUrl = url.absoluteString!
//                    print("imageUrl is: ", self.parent.imageUrl)
//                }
//            })
////            return hashString
//        }
//
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let uiImage = info[.originalImage] as? UIImage
            parent.image = Image(uiImage: uiImage!)
            if (parent.sourceType == .camera) {
                if let mediaData = uiImage?.jpegData(compressionQuality: 0.5) {
                   parent.imageData = mediaData
                }
                
//                saveImgToLocal(uiImage!)
//                var str = ""
//                let fetchOptions = PHFetchOptions()
//                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//                let allPhotos = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
//                let firstImage = allPhotos.firstObject
//                firstImage
            }
            else if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                parent.imageUrl = url.absoluteString
            }
//            if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
//                parent.imageUrl = url.absoluteString
//            }
            print("\nimageUrl is: ", parent.imageUrl, "\n")
//            if let mediaData = uiImage?.jpegData(compressionQuality: 0.5) {
//                parent.imageData = mediaData
//            }
            
            parent.showImagePicker = false
            parent.showActionSheetImage = false
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    
}


