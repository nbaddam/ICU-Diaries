//
//  Timeline.swift
//  ICU Diaries
//
//  Created by Zaher Hage on 10/2/21.
//
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct Timeline: View {
    
   @ObservedObject private var viewModel = PostViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Timeline")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Spacer()
                GeometryReader { geometry in
                    List {
                        ForEach(viewModel.posts, id: \.id) {(post) in
                            if !post.imageName.isEmpty {
                                PostView(hasImage: true, hasVideo: false, hasAudio: false, post: post, screenWidth: geometry.size.width)
                            }
                            else if !post.videoName.isEmpty {
                                PostView(hasImage: false, hasVideo: true, hasAudio: false, post: post, screenWidth: geometry.size.width)
                            }
                            else {
                                PostView(hasImage: false, hasVideo: false, hasAudio: false, post: post, screenWidth: geometry.size.width)
                            }
                        }
                    }.onAppear() {
                        self.viewModel.posts.removeAll()
                        self.viewModel.getData()
                    }
                }
                NavigationLink(destination: FilterView().navigationBarBackButtonHidden(false)) {
                    Text("Filter")
                }
            }
        }
    }
}

struct PlainGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
    }
}

//struct Timeline_Previews: PreviewProvider {
//    static var previews: some View {
//        Timeline()
//    }
//}


/*   Code to read message data for a specific patient
 
 let db = Firestore.firestore()
 let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
 docRef.getDocument { (document, error) in
     if let document = document, document.exists {
         let testing = document.get("code")
         db.collection("codes").document(testing as! String).collection("Messages").getDocuments() { (querySnapshot, error) in
             if let error = error {
                 print("Error getting documents: \(error)")
             }
             else {
                 for document in querySnapshot!.documents {
                     print("\(document.documentID): \(document.data())")
                 }//prints all documents in the firebase
             }//else
         }//get documents
     }
 }
 
 */
