//
//  LoginView.swift
//  KwikChat
//
//  Created by Abuzar Siddiqi on 2/22/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View {
    //Mark User Details
    @State var emailID: String = ""
    @State var password: String = ""
    //Mark: View Properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    //Mark: USer Defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    var body: some View {
        VStack(spacing: 10){
            Text("Kwikchat")
                .font (.largeTitle.bold())
                .hAlign(.leading)
            Text("Welcome back,\nYou have been missed")
                .font(.title3)
                .hAlign(.leading)

            VStack{
                TextField("Email",text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top,25)
                
                
                SecureField("Password",text: $password)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                Button("Reset password?", action: resetPassword)
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAlign(.trailing)
                Button(action: loginUser){
                    //Mark: Login Button
                    Text("Sign in")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top,10)
            }
            // Mark: Register Button
            HStack{
                Text("Don't have an account")
                    .foregroundColor(.gray)
                
                Button("Register Now"){
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        // Mark: Register View Via Sheets
        .fullScreenCover(isPresented: $createAccount){
            RegisterView()
        }
        //MArk: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    func loginUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                // With the help of Swift Concurrency Auth can be done with Single Line
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User Found")
                try await fetchUser()
            } catch {
                await setError(error)
            }
        }
    }
    
    //Mark: If User If Found then Fetching User Data From FireStore
    func fetchUser() async throws{
        guard let userID = Auth.auth().currentUser?.uid else {return}
       let user =  try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        // Mark: Ui Updating Must be Run On Main Thread
        await MainActor.run{
            // Setting UserDefaults data and Changing App's Auth Status
            userUID = userID
            userNameStored = user.username
            profileURL = user.userProfileURL
            logStatus = true
        }
    }
    func resetPassword(){
        Task{
            do{
                // With the help of Swift Concurrency Auth can be done with Single Line
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent")
            } catch {
                await setError(error)
            }
        }
    }
     
    // Mark: Displaying Errors Via Alert
    func setError(_ error: Error) async {
        //Mark: UI Must be Updated on Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}



// For Preview of Login View
#Preview {
    LoginView()
}
