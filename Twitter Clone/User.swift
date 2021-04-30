//
//  User.swift
//  Twitter Clone
//
//  Created by Kazim Walji on 4/25/21.
//

import Foundation

struct User {
    var feed: [Tweet] = []
    var followers: [User]?
    let username: String
    var tweets: [Tweet] = []
    
    mutating func getFeed()->[Tweet] {
        self.tweets = Api.getTweets(user: self)
        var feed: [Tweet] = []
        if self.followers != nil {
            for _ in self.followers!  {
                for tweet in self.tweets {
                    feed.append(tweet)
                }
        }
    }
        feed = feed + self.tweets
        feed.sort {
            if $0.date["month"] != $1.date["month"] {
                return $0.date["month"] ?? -1 > $1.date["month"] ?? 0
            }
            else if $0.date["day"] != $1.date["day"] {
                return $0.date["day"] ?? -1 > $1.date["day"] ?? 0
            }
            else if $0.date["hour"] != $1.date["hour"] {
                return $0.date["hour"] ?? -1 > $1.date["hour"] ?? 0
            } else {
                return $0.date["min"] ?? -1 > $1.date["min"] ?? 0
            }
        }
        print("feed: ", feed[0].text)
        self.feed = feed
        return feed
}
}
