//
//  GraphView.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//  Copyright © 2017 Dillon Fagan. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIScrollView {
    
    var isInEditMode = false
    
    var nodes = [NodeView]()
    
    private var colorCycle = 0
    
    private let colors = [
        // green
        UIColor(red: 0/255, green: 184/255, blue: 147/255, alpha: 1.0),
        // pink
        UIColor(red: 255/255, green: 0/255, blue: 128/255, alpha: 1.0),
        // blue
        UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0),
        // yellow
        UIColor(red: 245/255, green: 196/255, blue: 45/255, alpha: 1.0),
        // purple
        UIColor(red: 62/255, green: 23/255, blue: 160/255, alpha: 1.0)
    ]
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isInEditMode {
            for touch in touches {
                let location = touch.location(in: self)
                let node = NodeView(color: colors[colorCycle], at: location)
                
                nodes.append(node)
                
                addSubview(node)
                
                if colorCycle < colors.count - 1 {
                    colorCycle += 1
                } else {
                    colorCycle = 0
                }
            }
        }
    }
    
}
