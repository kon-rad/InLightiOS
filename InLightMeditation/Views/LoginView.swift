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
    @State private var showPassword: Bool = false
    @State private var errorMessage: String = ""
    
    @EnvironmentObject var session: FirebaseSession
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
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
                .font(.system(size: 15, weight: .regular, design: .default))
                .keyboardType(.default)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 60, alignment: .center)
            }
            .padding(.horizontal, 15)
            .background(Color.primary.opacity(0.05).cornerRadius(10))
            .padding(.horizontal, 15)
            .animation(nil)
            
            HStack{
                Image(systemName: "lock.fill")
                    .foregroundColor(password.isEmpty ? .secondary : .primary)
                    .font(.system(size: 18, weight: .medium, design: .default))
                    .frame(width: 18, height: 18, alignment: .center)
                secureField(placeholder: "Password", text: $password)
                if !password.isEmpty {
                    Button(action: {
                        self.showPassword.toggle()
                    }, label: {
                        ZStack(alignment: .trailing){
                            Color.clear
                                .frame(maxWidth: 29, maxHeight: 60, alignment: .center)
                            Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.init(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0))
                        }
                    })
                }
            }
            .padding(.horizontal, 15)
            .background(Color.primary.opacity(0.05).cornerRadius(10))
            .padding(.horizontal, 15)
            .animation(nil)
            if !isLogin {
                HStack{
                    Image(systemName: "lock.fill")
                        .foregroundColor(password.isEmpty ? .secondary : .primary)
                        .font(.system(size: 18, weight: .medium, design: .default))
                        .frame(width: 18, height: 18, alignment: .center)
                        secureField(placeholder: "Confirm Password", text: $confirmPassword)
                    if !password.isEmpty {
                        Button(action: {
                            self.showPassword.toggle()
                        }, label: {
                            ZStack(alignment: .trailing){
                                Color.clear
                                    .frame(maxWidth: 29, maxHeight: 60, alignment: .center)
                                Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color.init(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0))
                            }
                        })
                    }
                }
                .padding(.horizontal, 15)
                .background(Color.primary.opacity(0.05).cornerRadius(10))
                .padding(.horizontal, 15)
                .animation(nil)
                
            }
            Text(self.errorMessage)
                .foregroundColor(Color.red)
                .padding(15)
            Button(action: { loginOrSignup() }) {
                AuthButtonContent(isLogin: $isLogin)
            }
            .padding()
            Button(action: { toggleIsLogin() }) {
                Text(isLogin ? "Signup" :  "Login" )
            }
            .padding()
            Button(action: { toggleIsLogin() }) {
                Text("Sign In With Email Link")
            }
            .padding()
            .frame(maxWidth: 200, alignment: .center)
            .padding()
            Spacer()
            Spacer()
        }
        .navigationBarTitle("")
        .onAppear(perform: getUser)
    }
    @ViewBuilder
    func secureField(placeholder: String, text: Binding<String>) -> some View {
        if self.showPassword {
            TextField(placeholder, text: text)
                .font(.system(size: 15, weight: .regular, design: .default))
                .keyboardType(.default)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 60, alignment: .center)
                .animation(nil)
        } else {
            SecureField(placeholder, text: text)
                .font(.system(size: 15, weight: .regular, design: .default))
                .keyboardType(.default)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 60, alignment: .center)
                .animation(nil)
        }
    }
    //MARK: Functions
    func getUser() {
        session.listen()
    }
    func toggleIsLogin() {
        self.isLogin = !self.isLogin
    }
    func showMessagePrompt(message: String = "") {
        print("error message shown: ", message)
        self.errorMessage = message;
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
                    self.showMessagePrompt(message: error?.localizedDescription ?? "")
                } else {
                    self.email = ""
                    self.password = ""
                    print("logged in")
                    self.showMessagePrompt(message: "")
                }
            }
        } else {
            if !email.isEmpty && !password.isEmpty {
                session.signUp(email: email, password: password) { (result, error) in
                    if error != nil {
                        self.showMessagePrompt(message: error?.localizedDescription ?? "")
                    } else {
                        self.email = ""
                        self.password = ""
                        print("signed up")
                        self.showMessagePrompt(message: "")
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

struct ClearButton: ViewModifier
{
    @Binding var text: String

    public func body(content: Content) -> some View
    {
        ZStack(alignment: .trailing)
        {
            content

            if !text.isEmpty
            {
                Button(action:
                {
                    self.text = ""
                })
                {
                    Image(systemName: "delete.left")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 8)
            }
        }
    }
}
struct SecureInput: View {
    let placeholder: String
    @State private var showText: Bool = false
    @State var text: String
    var onCommit: (()->Void)?
    
    var body: some View {
        
        HStack {
            ZStack {
                SecureField(placeholder, text: $text, onCommit: {
                    onCommit?()
                })
                .opacity(showText ? 0 : 1)
                
                if showText {
                    HStack {
                        Text(text)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                }
            }
            
            Button(action: {
                showText.toggle()
            }, label: {
                Image(systemName: showText ? "eye.slash.fill" : "eye.fill")
            })
            .accentColor(.secondary)
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondary, lineWidth: 1)
                    .foregroundColor(.clear))
    }
    
}
