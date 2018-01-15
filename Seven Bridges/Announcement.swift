//
//  Announcement.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 1/14/18.
//

import UIKit

class Announcement {
    
    static func new(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}
