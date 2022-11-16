//
//  LoginView.swift
//  Food Explorer
//
//  Created by Dennis Sand on 10.11.22.
//

import SwiftUI
import Firebase

struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    @State private var presentSheet = false
    @FocusState private var focusField: Field?
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .padding()
    
            Group {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next) // no return - next !
                    .focused($focusField, equals: .email) // this field is bound to the .email case
                    .onSubmit {
                    focusField = .password
                } // goes to Passwoerd Field
                    .onChange(of: email) { _ in
                        enableButtons()
                    }
                
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done) // no return - done !
                    .focused($focusField, equals: .password)// this field is bound to the .password case
                    .onSubmit {
                        focusField = nil // will dismiss the keyboard
                    }
                    .onChange(of: password) { _ in
                        enableButtons()
                    }
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            HStack {
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                }
                .padding(.trailing)
                
                Button {
                    login()
                } label: {
                    Text("Log In")
                }
                .padding(.leading)
            }
            .disabled(buttonsDisabled)
            .buttonStyle(.borderedProminent)
            .tint(Color("FoodColor"))
            .font(.title2)
            .padding(.top)
     
            
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("Ok", role: .cancel) {}
        }
               
                .onAppear{
                    // if logged in when app runs, navigate to the new screen & skip login screen
                    if Auth.auth().currentUser != nil  {
                        print ("Login success !")
                        presentSheet = true
                    }
            }
                .fullScreenCover(isPresented: $presentSheet) {
                    ListView()
                }
    }
    
    func enableButtons () {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) {result,
            error in
            if let error = error { // login error occurred
                print("Signin Error: \(error.localizedDescription)")
                alertMessage = "Signin Error: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print ("Regestration success !")
                presentSheet = true
            }
        }
    }
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) {result,
            error in
            if let error = error { // login error occurred
                print("Login Error: \(error.localizedDescription)")
                alertMessage = "Login Error: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print ("Login success !")
                presentSheet = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
