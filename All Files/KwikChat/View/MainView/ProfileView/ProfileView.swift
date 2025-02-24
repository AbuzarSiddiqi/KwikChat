//
//  Profile.swift
//  KwikChat
//
//  Created by Abuzar Siddiqi on 2/23/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    // Mark: My Profile Data
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    // Mark: View Properties
    @State private var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    var body: some View {
        NavigationStack {
            VStack{
                if let myProfile{
                    ReusableProfileContent(user: myProfile)
                        .refreshable {
                            // Mark: Refresh User Data
                            self.myProfile = nil
                            await fetchUserData()
                        }
                }else{
                    ProgressView()
                }
            }
           
            .navigationTitle(Text("My Profile"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        //Mark: Two Action's
                        // 1. Logout
                        // 2. Delete Account
                        Button("Logout",action: logOutUser)
                        Button("Delete Account",role: .destructive,action: deleteAccount)
                    }label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }
                }
            }
        }
                    .overlay {
                        LoadingView(show: $isLoading)
                    }
                    .alert(errorMessage, isPresented: $showError){
                    }
                    .task {
                        //This Modidifier is like onAppear
                        //So Fetching for the First Time Only
                        if myProfile != nil{return}
                        //Mark: Initial Fetch
                        await fetchUserData()
                    }
                }
     // Mark: Fetching User Data
    func fetchUserData() async {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        do {
            let user = try await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self)
            await MainActor.run {
                self.myProfile = user
            }
        } catch {
            await setError(error)
        }
    }
    
         // Mark: Logging User Out
         func logOutUser(){
                    try? Auth.auth().signOut()
                    logStatus = false
                }
        //Mark: Delete User Entire Account
        func deleteAccount(){
            isLoading = true
                    Task{
                        do{
                            guard let userUID = Auth.auth().currentUser?.uid else { return }
                            // Step : First Deleting Profile Image from Storage
                            let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
                            try await reference.delete()
                            // Step 2: Deleting Firestore User Document
                            try await Firestore.firestore().collection("Users").document(userUID).delete()
                            // Step 3: Deleting Auth Account and Setting Log Status to False
                            try await Auth.auth().currentUser?.delete()
                            logStatus = false
                        }catch{
                            await setError(error)
                        }
                    }
                }
       //Mark: Setting error
       func setError(_ error: Error)async{
                //Mark: UI must be run on Main Thread
                await MainActor.run{
                    isLoading = false
                    errorMessage = error.localizedDescription
                    showError.toggle()
                    
                }
            }
            }
