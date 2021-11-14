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
import AVKit
import AVFoundation

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
    @State var videoData: NSData = NSData()
    @State var sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum
    @State var imageUrl = ""
    @State var videoUrl = ""
    @State var videoViewController = AVPlayerViewController();
    @State private var presentAlert = false
    @State var recordingSession: AVAudioSession!
    @State var audioRecorder: AVAudioRecorder!
    @State var recordButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64)).setTitle("Tap Mic to Record", for: .normal)
    @State var audioUrl = ""
    @State var micStatus = "mic"
    @State var recordStatus = "Tap Microphone to Record"
    
    func loadImage() {
        guard let inputImage = pickedImage else {return}
        print("assigning upload pic")
        uploadImage = inputImage
    }
    
//    func loadRecordingUI() {
//        recordButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64))
//        recordButton.setTitle("Tap to Record", for: .normal)
//        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
//        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
//    }
    
    func getDocumentsDirectory() throws -> URL {
         return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
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
            
            Text(recordStatus)
            Image(systemName: micStatus).resizable()
                .frame(width: 50, height: 50)
                .onTapGesture {
                    if (audioRecorder == nil) {
                        let uuid = UUID().uuidString
                        var audioFileName = ""
                        do {
                            audioFileName = try getDocumentsDirectory().appendingPathComponent(uuid + ".m4a").absoluteString
                            audioUrl = audioFileName
                        } catch {
                            print("error getting audio filename")
                        }
                        
                        let settings = [
                            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey: 12000,
                            AVNumberOfChannelsKey: 1,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                        ]

                        do {
                            audioRecorder = try AVAudioRecorder(url: URL(string: audioFileName)!, settings: settings)
                            audioRecorder.record()
                            recordStatus = "Tap Microphone to Stop"
                            micStatus = "mic.fill"
                        } catch {
                            audioRecorder.stop()
                            audioRecorder = nil

                            recordStatus = "Tap Microphone to Record"
                            micStatus = "mic"
                                    
                        }
                    } else {
                        audioRecorder.stop()
                        audioRecorder = nil
                        recordStatus = "Tap Microphone to Re-record"
                        micStatus = "mic"
                    }
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
                    let db = Firestore.firestore()
                    let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let testing = document.get("code")
                            let uid = Auth.auth().currentUser!.uid
                            let add_message = message
                            let time = Timestamp().self
                            let userStorageRef = StorageService.storagePosts.child(Auth.auth().currentUser!.uid)
                            let storageRef = userStorageRef.child(UUID().uuidString)
                            print(imageUrl)
                            if (imageUrl != "") {
                                storageRef.putFile(from: URL(string: imageUrl)!, metadata: StorageMetadata()) {
                                    (StorageMetadata, error) in
                                    print("inside storing pic")
                                    if error != nil {
                                        print("error storing pic")
                                        print(error!.localizedDescription)
                                        return
                                    }
                                    
                                    storageRef.downloadURL(completion: {
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
                                                                                                            "imageUrl": metaImageUrl,
                                                                                                            "videoUrl": ""])
                                            message = ""
                                            presentAlert = true
                                            imageUrl = ""
                                            videoUrl = ""
                                            pickedImage = nil
                                            uploadImage = nil
                                        }
                                    })
                                }
                            }
                            else if (imageData != Data()) {
                                storageRef.putData(self.imageData, metadata: StorageMetadata()) {
                                    (StorageMetadata, error) in
                                    print("inside storing pic")
                                    if error != nil {
                                        print("error storing pic")
                                        print(error!.localizedDescription)
                                        return
                                    }
                                    
                                    storageRef.downloadURL(completion: {
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
                                                                                                            "imageUrl": metaImageUrl,
                                                                                                            "videoUrl": ""])
                                            message = ""
                                            presentAlert = true
                                            imageUrl = ""
                                            videoUrl = ""
                                            pickedImage = nil
                                            uploadImage = nil
                                        }
                                    })
                                }
                            }
                            else if (videoUrl != "") {
                                storageRef.putFile(from: URL(string: videoUrl)!, metadata: StorageMetadata()
                                    , completion: { (metadata, error) in
                                        if let error = error {
                                            print(error)
                                        }
                                        
                                    storageRef.downloadURL(completion: {
                                        (url, error) in
                                        if (error != nil) {
                                            print("error downloading url")
                                            return
                                        }
                                        if let videoUrl = url?.absoluteString {
                                            db.collection("codes").document(testing as! String).collection("Messages").addDocument(data:
                                                                                                            ["Message": add_message,
                                                                                                            "Time": time,
                                                                                                            "UID": uid,
                                                                                                            "imageUrl": "",
                                                                                                            "videoUrl": videoUrl])
                                            message = ""
                                            presentAlert = true
                                            imageUrl = ""
                                            self.videoUrl = ""
                                            pickedImage = nil
                                            uploadImage = nil
                                        }
                                    }
                                )}
                            )}
                            else if (audioUrl != "") {
                                storageRef.putFile(from: URL(string: audioUrl)!, metadata: StorageMetadata()
                                    , completion: { (metadata, error) in
                                        if let error = error {
                                            print(error)
                                        }
                                        
                                    storageRef.downloadURL(completion: {
                                        (url, error) in
                                        if (error != nil) {
                                            print("error downloading url")
                                            return
                                        }
                                        if let audioUrl = url?.absoluteString {
                                            db.collection("codes").document(testing as! String).collection("Messages").addDocument(data:
                                                                                                            ["Message": add_message,
                                                                                                            "Time": time,
                                                                                                            "UID": uid,
                                                                                                            "imageUrl": "",
                                                                                                            "videoUrl": "",
                                                                                                            "audioUrl": audioUrl])
                                            message = ""
                                            presentAlert = true
                                            imageUrl = ""
                                            self.videoUrl = ""
                                            pickedImage = nil
                                            uploadImage = nil
                                        }
                                    }
                                )}
                            )}
                            else {
                                db.collection("codes").document(testing as! String).collection("Messages").addDocument(data:
                                                                                                ["Message": add_message,
                                                                                                "Time": time,
                                                                                                "UID": uid,
                                                                                                "imageUrl": "",
                                                                                                 "videoUrl": ""])
                                message = ""
                                presentAlert = true
                                imageUrl = ""
                                videoUrl = ""
                                pickedImage = nil
                                uploadImage = nil
                            }
                            
                        } else {
                            print("Document does not exist")
                        }
                    }//get document
                }//onTap
                
        }//Vstack
        .alert(isPresented: $presentAlert) {
             Alert(
                 title: Text("Message Posted!")
             )
         }
        .sheet(isPresented: $showingPicker, onDismiss: loadImage) {
            if (showingImagePicker) {
                ImagePicker(image: self.$pickedImage, imageData: self.$imageData, showImagePicker: self.$showingImagePicker, showActionSheetImage: self.$showingActionSheet, imageUrl: self.$imageUrl, sourceType: self.$sourceType)
            }
            else if (showingVideoPicker) {
                VideoPicker(videoUrl: self.$videoUrl, showVideoPicker: self.$showingVideoPicker, showActionSheetVideo: self.$showingActionSheet, thumbnail: self.$pickedImage, sourceType: self.$sourceType)
            }
        }.actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text(""), buttons: [
                .default(Text("Choose A Photo")){
                    self.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                    self.showingPicker = true
                    self.showingImagePicker = true
                    self.videoUrl = ""
                    self.uploadImage = nil
                },
                .default(Text("Take A Photo")){
                    self.sourceType = UIImagePickerController.SourceType.camera
                    self.showingPicker = true
                    self.showingImagePicker = true
                    self.videoUrl = ""
                    self.uploadImage = nil
                },
                .default(Text("Choose A Video")){
                    self.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                    self.showingPicker = true
                    self.showingVideoPicker = true
                    self.imageUrl = ""
                    self.uploadImage = nil
                },
                .default(Text("Take A Video")){
                    self.sourceType = UIImagePickerController.SourceType.camera
                    self.showingPicker = true
                    self.showingVideoPicker = true
                    self.imageUrl = ""
                    self.uploadImage = nil
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
    
    func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler: @escaping (AVAssetExportSession) -> Void) {
        try! FileManager.default.removeItem(at: outputURL as URL)
        let asset = AVURLAsset(url: inputURL as URL, options: nil)

        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously(completionHandler: {
            handler(exportSession)
        })
    }
    
}//UploadView

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
            
    }
}

//
//func uploadTOFireBaseVideo(url: URL,
//                                  success : @escaping (String) -> Void,
//                                  failure : @escaping (Error) -> Void) {
//
//    let name = "\(Int(Date().timeIntervalSince1970)).mp4"
//    let path = NSTemporaryDirectory() + name
//
//    let dispatchgroup = DispatchGroup()
//
//    dispatchgroup.enter()
//
//    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    let outputurl = documentsURL.appendingPathComponent(name)
//    var ur = outputurl
////    self.convertVideo(toMPEG4FormatForVideo: url as URL, outputURL: outputurl) { (session) in
////
////        ur = session.outputURL!
////        dispatchgroup.leave()
////
////    }
//    dispatchgroup.wait()
//
//    let data = NSData(contentsOf: ur as URL)
//
//    do {
//
//        try data?.write(to: URL(fileURLWithPath: path), options: .atomic)
//
//    } catch {
//
//        print(error)
//    }
//
//
//}
