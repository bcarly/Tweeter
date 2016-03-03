//
//  User.swift
//  Twitter
//
//  Created by Carly Burroughs on 2/21/16.
//  Copyright © 2016 Carly Burroughs. All rights reserved.
//

import UIKit


class User: NSObject {
    
    var name: String?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var followersCount: Int = 0
    var profileBackgroundUrl: NSURL?
    var followingCount: Int = 0
    var tweetsCount: Int = 0

    
    var dictionary: NSDictionary?
    
    static let userDidLogoutNotification = "UserDidLogout"


    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        let profileBackgroundUrlString = dictionary["profile_background_image_url_https"] as? String
        if let profileBackgroundUrlString = profileBackgroundUrlString {
            profileBackgroundUrl = NSURL(string: profileBackgroundUrlString)
        }
        
        tagline = dictionary["description"] as? String
        followersCount = (dictionary["followers_count"] as? Int) ?? 0
        followingCount = (dictionary["friends_count"] as? Int) ?? 0
        tweetsCount = (dictionary["statuses_count"] as? Int) ?? 0
    }

    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
            
                let userData = defaults.objectForKey("currentUserData") as? NSData
            
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
    
            defaults.synchronize()
        }
    }
}

