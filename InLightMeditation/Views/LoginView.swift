//
//  LoginView.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 11/11/21.
//

import SwiftUI
import Firebase

struct LoginView: View {
    var body: some View {
        VStack {
            Text("Login!")
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
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
