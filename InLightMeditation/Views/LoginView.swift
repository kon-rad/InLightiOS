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
                    TextField(
                        "Password",
                        text: $password,
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
    func login() {
        let email = ""
        let password = ""
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(
                    title: "Sign in Failed",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(title: "OK", style: .default))

                print("error")
            } else {
                print("logged in")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
