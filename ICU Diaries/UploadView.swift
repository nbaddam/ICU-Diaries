//
//  UploadView.swift
//  ICU Diaries
//
//  Created by Zaher Hage on 10/27/21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UploadView: View {
    @State var message = ""
    @State var uploadImage: Image? = nil
    @State var pickedImage: Image? = nil
    @State var showingActionSheet = false
    @State var showingActionSheetImage = false
    @State var showingActionSheetVideo = false
    @State var showingPicker = false
    @State var showingImagePicker = false
    @State var showingVideoPicker = false
    @State var imageData: Data = Data()
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var imageUrl = ""
    @State var videoUrl: URL? = nil

    func loadImage() {
        guard let inputImage = pickedImage else {return}
        print("assigning upload pic")
        uploadImage = inputImage
    }
    
    var body: some View {
        VStack{
            if uploadImage != nil {
                uploadImage!.resizable()
                    .frame(width: 200, height: 200)
                    .padding(.top, 20)
                    .onTapGesture {
                        self.showingActionSheet = true
                    }
            } else {
                Image(systemName: "plus.rectangle").resizable()
                    .frame(width: 200, height: 150)
                    .padding(.top, 20)
                    .onTapGesture {
                        self.showingActionSheet = true
                    }
            }
            HStack {
                Image(systemName: "photo.fill").resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture(perform: {
                        self.showingActionSheet = true
                    })
                Image(systemName: "video.square").resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture(perform: {
                        print("insert video clicked")
                        print(self.showingActionSheetVideo)
                        self.showingActionSheet = true
                    })
            }
            Text("Message:")
                TextField(
                    "Type Here",
                    text: $message)
                    .cornerRadius(5)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
            Text("Upload")
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(2)
                .foregroundColor(.white)
                .onTapGesture {
                    print("upload clicked")
                    print(videoUrl?.absoluteString)
                    let db = Firestore.firestore()
                    let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let testing = document.get("code")
                            let uid = Auth.auth().currentUser!.uid
                            let add_message = message
                            let time = Timestamp().self
                            if (imageData != Data()) {
                                let storagePostRef = StorageService.storagePosts.child(Auth.auth().currentUser!.uid)
                                storagePostRef.putData(imageData, metadata: StorageMetadata()) {
                                    (StorageMetadata, error) in
                                    print("inside storing pic")
                                    if error != nil {
                                        print("error storing pic")
                                        print(error!.localizedDescription)
                                        return
                                    }
                                    
                                    storagePostRef.downloadURL(completion: {
                                        (url, error) in
                                        if (error != nil) {
                                            print("error downloading url")
                                            return
                                        }
                                        if let metaImageUrl = url?.absoluteString {
                                            db.collection("codes").document(testing as! String).collection("Messages").addDocument(data:
                                                                                                            ["Message": add_message,
                                                                                                            "Time": time,
                                                                                                            "UID": uid,
                                                                                                            "imageUrl": metaImageUrl])
                                            message = ""
                                        }
                                        else {
                                            db.collection("codes").document(testing as! String).collection("Messages").addDocument(data:
                                                                                                            ["Message": add_message,
                                                                                                            "Time": time,
                                                                                                            "UID": uid,
                                                                                                            "imageUrl": ""])
                                            message = ""
                                        }
                                    })
                                }
                            }
                            else {
                                db.collection("codes").document(testing as! String).collection("Messages").addDocument(data:
                                                                                                ["Message": add_message,
                                                                                                "Time": time,
                                                                                                "UID": uid,
                                                                                                "imageUrl": ""])
                                message = ""
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }//get document
                }//onTap
                
        }//Vstack
        .sheet(isPresented: $showingPicker, onDismiss: loadImage) {
            if (showingImagePicker) {
                ImagePicker(image: self.$pickedImage, imageData: self.$imageData, showImagePicker: self.$showingImagePicker, showActionSheetImage: self.$showingActionSheet)
            }
            else if (showingVideoPicker) {
                VideoPicker(videoUrl: self.$videoUrl, showVideoPicker: self.$showingVideoPicker, showActionSheetVideo: self.$showingActionSheet)
            }
        }.actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text(""), buttons: [	
                .default(Text("Choose A Photo")){
                    self.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                    self.showingPicker = true
                    self.showingImagePicker = true
                },
                .default(Text("Take A Photo")){
                    self.sourceType = UIImagePickerController.SourceType.camera
                    self.showingPicker = true
                    self.showingImagePicker = true

                },
                .default(Text("Choose A Video")){
                    self.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                    self.showingPicker = true
                    self.showingVideoPicker = true
                },
                .default(Text("Take A Video")){
                    self.sourceType = UIImagePickerController.SourceType.camera
                    self.showingPicker = true
                    self.showingVideoPicker = true

                },.cancel()
                ])
        }
        /*
        .sheet(isPresented: $showingVideoPicker, onDismiss: loadImage) {
            VideoPicker(videoUrl: self.$videoUrl, showVideoPicker: self.$showingVideoPicker, showActionSheetVideo: self.$showingActionSheetVideo)
        }.actionSheet(isPresented: $showingActionSheetVideo) {
            ActionSheet(title: Text(""), buttons: [
                .default(Text("Choose A Video")){
                    self.sourceType = .savedPhotosAlbum
                    self.showingVideoPicker = true
                },
                .default(Text("Take A Video")){
                    self.sourceType = .camera
                    self.showingVideoPicker = true

                }, .cancel()
                ])
        }
         */
        
        
        
        
    }//body
    
}//UploadView

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
            
    }
}
