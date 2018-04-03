//
//  UILabel+Extension.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 4/3/18.
//

import UIKit

extension UILabel {
    
    /// Changes the text of the UILabel with a crossfade transition.
    ///
    /// - parameter to: The new text for the label.
    /// - parameter duration: How long (in seconds) the transition should last for.
    ///
    func changeTextWithFade(to newText: String, duration: Double = 0.5) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.text = newText
        }, completion: nil)
    }
}
