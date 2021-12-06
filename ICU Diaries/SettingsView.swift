//
//  SettingsView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/8/21.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import URLImage

struct SettingsView: View {
    @State private var SignOutSuccess: Bool? = false
    @State var code = ""
    @State var codes: [String] = []
    @State var isCodeMatch: Bool = false
    @State var showError: Bool = false
    @State var typing: Bool = false
    @State var isPatient: Bool
    @State var patient_code: String
    @State var isFamily: Bool
    @State var presentAlert: Bool = false
    @State var copiedToClip: Bool = false
    @State var showingActionSheet = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var showingImagePicker = false
    @State var profileImage: Image? = nil
    @State var pickedImage: Image? = nil
    @State var imageData: Data = Data()
    @State var imageUrl = ""
    @State var displayUrl = Auth.auth().currentUser?.photoURL?.absoluteString
    @State var changedPic: Bool = false
    
    func loadImage() {
        guard let inputImage = pickedImage else {return}
        print("assigning profile pic")
        profileImage = inputImage
        let user = Auth.auth().currentUser
        let storageProfileImageRef = StorageService.storageProfile.child(user!.uid)
        storageProfileImageRef.putFile(from: URL(string: imageUrl)!, metadata: StorageMetadata()) {
            (StorageMetadata, error) in
            print("inside storing pic")
            if error != nil {
                print("error storing pic")
                print(error!.localizedDescription)
                return
            }
            
            storageProfileImageRef.downloadURL(completion: {
                (url, error) in
                if (error != nil) {
                    print("error downloading url")
                    return
                }
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = url
                changeRequest?.commitChanges{ error in
                    if error != nil {
                        print("error storing profile picture")
                    }
                    let db = Firestore.firestore();
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                        "profileImageUrl": url?.absoluteString
                    ]) { error in
                        if error != nil {
                            print("error updating profile picture URL in database")
                        }
                        displayUrl = url?.absoluteString
                        changedPic = true
                        Auth.auth().currentUser?.reload(completion: { error in
                            if error != nil {
                                print("error reloading user")
                            }
                        })
                    }
                }
            })
        }
//        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//        changeRequest?.photoURL = URL(string: imageUrl)
//        changeRequest?.commitChanges{ error in
//            if error != nil {
//                print("error storing profile picture")
//            }
//        }
//        Auth.auth().currentUser?.reload(completion: { error in
//            if error != nil {
//                print("error reloading user")
//            }
//        })
//        let db = Firestore.firestore();
//        db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
//            "profileImageUrl": imageUrl
//        ])
    }
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), tag: true, selection: $SignOutSuccess) {
                EmptyView()
            }
            Text("Sign Out")
                .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarHidden(true)
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(8)
                .foregroundColor(.white)
                .onTapGesture {
                    do {
                        try Auth.auth().signOut()
                        SignOutSuccess = true;
                    }
                    catch {
                        print("didnt work try again")
                    }
                }//onTap
            if (displayUrl != nil && !changedPic) {
                URLImage(URL(string: displayUrl!)!) { image in
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.top, 20)
                        .onTapGesture {
                            print("changing from urlimage")
                            print("changedPic status: ", changedPic)
                            self.showingActionSheet = true
                        }
                }
            }
            else if (profileImage != nil) {
                profileImage!.resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.top, 20)
                    .onTapGesture {
                        print("changing from profileImage")
                        print("changedPic status: ", changedPic)
                        self.showingActionSheet = true
                    }
            }
//            if let imageUrl = Auth.auth().currentUser?.photoURL?.absoluteString, imageUrl != ""  {
//                URLImage(URL(string: imageUrl)!) { image in
//                    image
//                        .resizable()
//                        .frame(width: 100, height: 100)
//                        .clipShape(Circle())
//                        .padding(.top, 20)
//                        .onTapGesture {
//                            self.showingActionSheet = true
//                        }
//                }
//            }
            else {
                Image(systemName: "person.circle.fill").resizable()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                    .padding(.top, 20)
                    .onTapGesture {
                        print("changing from no image")
                        print("changedPic status: ", changedPic)
                        self.showingActionSheet = true
                    }
            }
            Text("Change your Profile Picture")
                .onTapGesture(perform: {
                    self.showingActionSheet = true
                })
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text(""), buttons: [
                        .default(Text("Choose A Photo")){
                            self.sourceType = .savedPhotosAlbum
                            self.showingImagePicker = true
                        },
                        .default(Text("Take A Photo")){
                            self.sourceType = .camera
                            self.showingImagePicker = true
                        }, .cancel()
                        ])
                }
            Spacer()
            Spacer()
            
            if(isPatient == true){
                HStack {
                    Text("Patient Code: " + patient_code)
                        .alert(isPresented: $copiedToClip) {
                            Alert(
                                title: Text("Code Copied to Clipboard!")
                            )
                        }
                    Button(action: {
                        UIPasteboard.general.string = self.patient_code
                        print("Copied to clipboard")
                        copiedToClip = true
                    }) {
                        Image(systemName: "doc.on.doc")
                        }
                }
            }//if isPatient
            
            if(isFamily == true){
                Text("Patient Code:")
                    TextField(
                        "Type Here",
                        text: $code,
                        onEditingChanged: {(isChanged) in
                            if self.code.isEmpty {
                                showError = false
                            }
                        }
                    )
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(12)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(maxWidth: (UIScreen.screenWidth - 50))
                    .background(RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(
                                    showError ? Color.red : Color(UIColor.lightGray),
                                    lineWidth: typing ? 3 : 1
                                ))
                    .onTapGesture {
                        typing = true
                        if self.code.isEmpty && showError {
                            showError = false
                        }//if
                    }//ontap
            
            
            if !isCodeMatch && showError {
                Text(CODE_NOT_FOUND_ERR)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.red)
            }//if
            
            Text("Assign")
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(8)
                .foregroundColor(.white)
                .onTapGesture {
                    typing = false
                    let db = Firestore.firestore()
                    let user_code = db.collection("users").document(Auth.auth().currentUser!.uid)
                    db.collection("codes").getDocuments() { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                            isCodeMatch = false
                            showError = false
                            presentAlert = false
                        }
                        else {
                            for document in querySnapshot!.documents {
                                if(document.documentID == code){
                                    user_code.updateData(["code" : code])
                                    self.codes += [code]
                                    break
                                }
                            }//prints all documents in the firebase
                            if !codes.contains(code){
                                print("code NOT found")
                                isCodeMatch = false
                                showError = true
                                presentAlert = false
                            }
                            else {
                                print("code found")
                                isCodeMatch = true
                                showError = false
                                presentAlert = true
                                code = ""
                            }
                        }//else
                    }//getDocuments
                }//onTap
                .alert(isPresented: $presentAlert) {
                     Alert(
                         title: Text("Patient Code Assigned!")
                     )
                 }
            }//if is family
            Spacer()
        }//Vstack
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$pickedImage, imageData: self.$imageData, showImagePicker: self.$showingImagePicker, showActionSheetImage: self.$showingActionSheet, imageUrl: self.$imageUrl, sourceType: self.$sourceType)
        }
    }// Body View
}//SettingsView
/*
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
*/
