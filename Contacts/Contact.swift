//
//  Contact.swift
//  Contacts
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 7/25/17.
//

import Foundation

class Contact {
    
    let id: Int
    var avatarURL: String
    var firstName: String
    var lastName: String
    var email: String
    var gender: String
    var birthday: Date
    var address: String
    var city: String
    var state: String
    var country: String
    
    // MARK: - Initialization
    
//    init() {
//        
//    }
    
    init(fromJSON json: [String:Any]) {
        self.id = json["id"] as! Int
        self.avatarURL = json["avatar"] as! String
        self.firstName = json["first_name"] as! String
        self.lastName = json["last_name"] as! String
        self.email = json["email"] as! String
        self.gender = json["gender"] as! String
        let dateString = json["birthday"] as! String
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        self.birthday = formatter.date(from: dateString)!
        self.address = (json["street_number"] as! String) + " " + (json["address"] as! String)
        self.city = json["city"] as! String
        self.state = json["state"] as! String
        self.country = json["country"] as! String
    }
}
