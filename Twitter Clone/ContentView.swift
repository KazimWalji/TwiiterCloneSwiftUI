//
//  ContentView.swift
//  Twitter Clone
//
//  Created by Kazim Walji on 4/22/21.
//

import SwiftUI

var currentUser = User(username: "Admin")
struct ContentView: View {
    @State private var done = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    topImage().offset(y: -80)
                    Spacer()
                    Text("See what's happening in the world right now").font(.system(size: 30, weight: .heavy, design: .default)).foregroundColor(.black).padding().frame(minWidth: 350).multilineTextAlignment(.center)
                    NavigationLink(destination: SignUpView()) {
                        Text("Create account").font(.system(size: 25, weight: .heavy, design: .default)).foregroundColor(.white).padding().frame(minWidth: 350).background(Theme.blue).cornerRadius(30)
                    }
                    Spacer()
                    HStack {
                        Text("Have an account? ").font(.system(size: 20)).foregroundColor(Color.black)
                        Button(action: {
                            done = true
                        }, label: {
                            Text("Log in").font(.system(size: 20)).foregroundColor(Theme.blue)
                        }).buttonStyle(PlainButtonStyle())
                    }
                }
            }.navigate(to: LogInView(), when: $done)
        }.navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SignUpView: View {
    @State public var username: String = ""
    @State private var password: String = ""
    @State private var done: Bool = false
    @State private var showAlert: Bool = false
    var body: some View {
        ZStack {
            VStack {
                topImage()
                Spacer()
                TextField("Username", text: $username, onEditingChanged: { (changed) in
                    print(username)
                }).padding(10)
                    .font(Font.system(size: 25))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.gray, lineWidth: 1)).padding()
                SecureField("Password", text: $password).padding(10)
                    .font(Font.system(size: 25))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.gray, lineWidth: 1)).padding()
                Button (action: {
                    currentUser = Api.getUser(username: username, password: password, login: false)
                    if currentUser != nil {
                        done = true
                        currentUser.getFeed()
                    } else {
                        showAlert = true
                       done = false
                    }
                }, label: {
                    Text("Sign Up").font(.system(size: 25, weight: .heavy, design: .default)).foregroundColor(.white).padding().frame(minWidth: 350).background(Theme.blue).cornerRadius(30)
                }).alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text("Unable to sign up"), dismissButton: .default(Text("Ok")))
                }
                Spacer()
            }
        }.navigate(to: Home(username: $username), when: $done).navigationBarBackButtonHidden(true)
    }
}
struct LogInView: View {
    @State public var username: String = ""
    @State private var password: String = ""
    @State private var done: Bool = false
    @State private var showAlert: Bool = false
    var body: some View {
        ZStack {
            VStack {
                topImage()
                Spacer()
                TextField("Username", text: $username, onEditingChanged: { (changed) in
                }).padding(10)
                    .font(Font.system(size: 25))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.gray, lineWidth: 1)).padding()
                SecureField("Password", text: $password).padding(10)
                    .font(Font.system(size: 25))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.gray, lineWidth: 1)).padding()
                Button (action: {
                    currentUser = Api.getUser(username: username, password: password, login: true)
                    if currentUser != nil {
                        done = true
                        currentUser.getFeed()
                    } else {
                        showAlert = true
                       done = false
                    }
                }, label: {
                    Text("Log in").font(.system(size: 25, weight: .heavy, design: .default)).foregroundColor(.white).padding().frame(minWidth: 350).background(Theme.blue).cornerRadius(30)
                }).alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text("Unable to sign in"), dismissButton: .default(Text("Ok")))
                }
                Spacer()
            }
        }.navigate(to: Home(username: $username), when: $done)
    }
}
struct Home: View {
    @State private var text: String = ""
    @Binding public var username: String
    let timer = Timer.publish(every: 5, on: .init(), in: .common).autoconnect()
    @State private var feed = currentUser.getFeed()
    var body: some View {
        VStack {
            List {
                ForEach(feed , id: \.self) { tweet in
                    Text(tweet.text)
                }
            }.onReceive(timer, perform: { _ in
                feed = currentUser.getFeed()
            })
            TextField("Text", text: $text, onEditingChanged: { (changed) in
            }).padding(10)
                .font(Font.system(size: 25))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.gray, lineWidth: 1)).padding()
            Button (action: {
                Api.postTweet(username: username, text: text)
                let tweets = Api.getTweets(user: currentUser)
                if tweets.count > 0 {
                    currentUser.tweets = tweets
                    currentUser.getFeed()
                }
            }, label: {
                Text("Tweet").font(.system(size: 25, weight: .heavy, design: .default)).foregroundColor(.white).padding().frame(minWidth: 350).background(Theme.blue).cornerRadius(30)
            })
        }
    }
}
struct topImage: View{
    var body: some View {
        Image(uiImage: UIImage(named: "logo")!).resizable().frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct Theme {
    static let blue = Color(UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1.0))
    static let gray = Color(UIColor.systemGray3)
}

extension View {

    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)

                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
    }
}
