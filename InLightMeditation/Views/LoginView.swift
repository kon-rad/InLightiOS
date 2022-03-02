//
//  LoginView.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 11/11/21.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLogin: Bool = true
    
    @EnvironmentObject var session: FirebaseSession
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack {
                    TextField(
                        "Email",
                        text: $email,
                        onEditingChanged: { (isBegin) in
                            if isBegin {
                                print("Begins editing")
                            } else {
                                print("Finishes editing")
                            }
                        },
                        onCommit: {
                            print("commit")
                        }
                    )
                    .padding(10)
                    Button(action: { loginOrSignup() }) {
                        AuthButtonContent(isLogin: $isLogin)
                    }
                    .padding(10)
                    Button(action: { toggleIsLogin() }) {
                        Text("Login")
                    }
                    .padding(10)
                        
                }
                .frame(maxWidth: 200, alignment: .center)
                .padding(60)
            }
            Spacer()
            Spacer()
            Spacer()
        }
        .navigationBarTitle("")
        .onAppear(perform: getUser)
    }
    
    //MARK: Functions
    func getUser() {
        session.listen()
    }
    func toggleIsLogin() {
        self.isLogin = !self.isLogin
    }
    func showMessagePrompt(message: String) {
        print("message: ", message)
    }
    func loginOrSignup() {
        let actionCodeSettings = ActionCodeSettings()
        
        let scheme = "https"
        let uriPrefix = "inlight.page.link"
        let queryItemEmailName = "email"
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = uriPrefix
        
        
        actionCodeSettings.url = URL(string: "https://inlight-281fb.firebaseapp.com")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: email,
                                   actionCodeSettings: actionCodeSettings) { error in
          // ...
            if let error = error {
                self.showMessagePrompt(message: error.localizedDescription)
              return
            }
            // The link was successfully sent. Inform the user.
            // Save the email locally so you don't need to ask the user for it again
            // if they open the link on the same device.
            UserDefaults.standard.set(email, forKey: "Email")
            self.showMessagePrompt(message: "Check your email for link")
            // ...
        }
        
        
//        if isLogin {
//            session.logIn(email: email, password: password) { (result, error) in
//                if error != nil {
//                    print("Login Error", error)
//                } else {
//                    self.email = ""
//                    self.password = ""
//                    print("logged in")
//                }
//            }
//        } else {
//            if !email.isEmpty && !password.isEmpty {
//                session.signUp(email: email, password: password) { (result, error) in
//                    if error != nil {
//                        print("Signup Error", error)
//                    } else {
//                        self.email = ""
//                        self.password = ""
//                        print("signed up")
//                    }
//                }
//            }
//        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct AuthButtonContent : View {
    @Binding var isLogin: Bool
    var body: some View {
        return Text(isLogin ? "LOGIN" : "SIGNUP")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 180, height: 46)
            .background(isLogin ? Color.green : Color.blue)
            .cornerRadius(12.0)
    }
}

