//
//  PatientProfiles.swift
//  ICU Diaries
//
//  Created by jacob kurian on 11/14/21.
//

import Foundation
import SwiftUI
import URLImage
//
//protocol SearchDelegate {
//    func searchPatients(_ input: String)
//}
//
//class PatientAcquire: SearchDelegate {
//    func searchPatients(_ input: String) {
//        isLoading = true
//
//        SearchService.searchPatient(input: value) {
//            (patients) in
//            self.isLoading = false
//            self.patients = patients
//        }
//    }
//}


struct PatientProfile: View {
    @Environment(\.presentationMode) var presentationMode
    @State var value = ""
    @State var patients: [Patient] = []
    @State var isLoading = false
    @Binding var selectedPatient: Patient
    @Binding var showingPatientPicker: Bool
    let defaultProfile = "https://www.google.com/imgres?imgurl=https%3A%2F%2Fcdn.business2community.com%2Fwp-content%2Fuploads%2F2017%2F08%2Fblank-profile-picture-973460_640.png&imgrefurl=https%3A%2F%2Fwww.business2community.com%2Fsocial-media%2Fimportance-profile-picture-career-01899604&tbnid=ZbfgeaptF8Y5ZM&vet=12ahUKEwiZ-Jn7ipn0AhUVQa0KHeBtCUMQMygBegUIARDMAQ..i&docid=Smb2EEjVhvpzWM&w=640&h=640&q=profile%20picture&ved=2ahUKEwiZ-Jn7ipn0AhUVQa0KHeBtCUMQMygBegUIARDMAQ"
    
    
    func searchPatients() {
        isLoading = true

        SearchService.searchPatient(input: value) {
            (patients) in
            self.isLoading = false
            self.patients = patients
        }
    }
    var body: some View {
        ScrollView {
            VStack {
                SearchBar(searchUsers: self.$value).padding()
                    .onChange(of: value, perform: {
                        new in
                        searchPatients()
                    })
                if !isLoading {
                    ForEach(patients, id: \.id) {
                        (patient) in

                        HStack {
                            URLImage(URL(string: patient.profileImageUrl) ?? URL(string: defaultProfile)!) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                            }
                            Text(patient.name)
                                .onTapGesture {
                                    self.selectedPatient = patient
                                    showingPatientPicker = false
                                    //DoctorUploadView(patient: self.selectedPatient)
                                    presentationMode.wrappedValue.dismiss()
                                }
                        }
                    }
                }
            }
        }
    }
}
