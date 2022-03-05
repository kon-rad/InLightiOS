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
    @State private var isMagicLogin: Bool = false
    
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
                    .textFieldStyle(.roundedBorder)
                    .padding(10)
                    
                    SecureField(
                        "Password",
                        text: $password
                    )
                    .padding(10)
                    .textFieldStyle(.roundedBorder)
                    if !isLogin {
                        SecureField(
                            "Confirm Password",
                            text: $confirmPassword
                        )
                        .padding(10)
                        .textFieldStyle(.roundedBorder)
                        
                    }
                    Button(action: { loginOrSignup() }) {
                        AuthButtonContent(isLogin: $isLogin)
                    }
                    .padding(40)
                    Button(action: { toggleIsLogin() }) {
                        Text("Login")
                    }
                    .padding(10)
                    Button(action: { toggleIsLogin() }) {
                        Text("Sign In With Email Link")
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
        
        if isMagicLogin {
            
            // MARK - sign in with email link
            
            let actionCodeSettings = ActionCodeSettings()
            
            let scheme = "https"
            let uriPrefix = "inlight.page.link"
            let queryItemEmailName = "email"
            
            var components = URLComponents()
            components.scheme = scheme
            components.host = uriPrefix
            components.path = "/open"
            
            let emailURLQueryItem = URLQueryItem(name: queryItemEmailName, value: email)
            
            guard let linkParameters = components.url else { return }
            print("link param is: ", linkParameters);
            
            actionCodeSettings.url = linkParameters
            
            components.queryItems = [emailURLQueryItem]
            
            actionCodeSettings.url = linkParameters
            // The sign-in operation has to always be completed in the app.
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            
            Auth.auth().sendSignInLink(
                toEmail: email,
                actionCodeSettings: actionCodeSettings
            ) { error in
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
            return;
        }
        
        // MARK login or sign up with password
        if isLogin {
            session.logIn(email: email, password: password) { (result, error) in
                if error != nil {
                    print("Login Error", error)
                } else {
                    self.email = ""
                    self.password = ""
                    print("logged in")
                }
            }
        } else {
            if !email.isEmpty && !password.isEmpty {
                session.signUp(email: email, password: password) { (result, error) in
                    if error != nil {
                        print("Signup Error", error)
                    } else {
                        self.email = ""
                        self.password = ""
                        print("signed up")
                    }
                }
            }
        }
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

