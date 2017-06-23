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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isInEditMode {
            for touch in touches {
                let location = touch.location(in: self)
                let node = NodeView(at: location)
                addSubview(node)
            }
        }
    }
    
}
