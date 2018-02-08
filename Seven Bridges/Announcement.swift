//
//  Announcement.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 1/14/18.
//

import UIKit

class Announcement {
    
    static func new(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}
