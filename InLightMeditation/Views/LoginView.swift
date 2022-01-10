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
                    SecureField(
                        "Password",
                        text: $password
                    )
                    .padding(10)
                    if !isLogin {
                        SecureField(
                            "Confirm Password",
                            text: $confirmPassword
                        )
                        .padding(10)
                        
                    }
                    Button(action: { loginOrSignup() }) {
                        AuthButtonContent(isLogin: $isLogin)
                    }
                    .padding(10)
                    Button(action: { toggleIsLogin() }) {
                        // this is flipped to toggle the auth flow
                        Text(isLogin ? "Signup" : "Login")
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
    }
    func toggleIsLogin() {
        self.isLogin = !self.isLogin
    }
    func loginOrSignup() {
        if isLogin {
            session.logIn(email: email, password: password) { (result, error) in
                if error != nil {
                    print("Login Error", error)
                } else {
                    self.email = ""
                    self.password = ""
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

