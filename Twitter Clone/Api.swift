//
//  Api.swift
//  Twitter Clone
//
//  Created by Kazim Walji on 4/24/21.
//

import Foundation

struct Api {
    static func getUser(username:String, password:String, login:Bool)->User  {
        let url = URL(string:"http://127.0.0.1:5000/user/" + username + "/" + password)!
        var request = URLRequest(url: url)
        let decoder = JSONDecoder()
        var user:User? = nil
        if login {
            request.httpMethod = "GET"
            let sem = DispatchSemaphore.init(value: 0)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                defer { sem.signal() }
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String:Any] {
                    let username = responseJSON["username"] as? String ?? ""
                    user = User(username: username)
                }
            }

            task.resume()
            sem.wait()
            return user ?? User(username: "Admin")
        } else {
        request.httpMethod = "POST"
        let sem = DispatchSemaphore.init(value: 0)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                defer { sem.signal() }
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String:Any] {
                    let username = responseJSON["username"] as? String ?? ""
                    user = User(username: username)
                }
            }

            task.resume()
            sem.wait()
            return user ?? User(username: "Admin")
        }
    }
    static func postTweet(username: String, text: String)->Bool {
        var bool = false
        var urlString = "http://127.0.0.1:5000/tweets/" + username + "/" + text
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let sem = DispatchSemaphore.init(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [Bool] {
                bool = responseJSON[0]
                return
            }
        }
        task.resume()
        sem.wait()
        return bool
    }
    static func getTweets(user:User)->[Tweet] {
        print("getTweets")
        var tweets = [Tweet]()
    let url = URL(string:"http://127.0.0.1:5000/tweets/" + user.username)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sem = DispatchSemaphore.init(value: 0)
        let decoder = JSONDecoder()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
                do {
                    tweets = try decoder.decode([Tweet].self, from: data)
                } catch {
                    print("Failed to decode JSON")
                return
            }
        }
        task.resume()
        sem.wait()
        return tweets
    }
    
}
