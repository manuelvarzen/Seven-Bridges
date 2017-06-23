//
//  EdgeView.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//  Copyright © 2017 Dillon Fagan. All rights reserved.
//

import UIKit

@IBDesignable class EdgeView: UIView {
    
    // Thickness of the line
    private let lineWidth = CGFloat(4)
    
    // Node where the Edge originates
    var startNode: NodeView?
    
    // Node where the Edge ends
    var endNode: NodeView?
    
    init(from startNode: NodeView, to endNode: NodeView, frame: CGRect) {
        self.startNode = startNode
        self.endNode = endNode
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        // draw a line
        // set coordinates based on startNode, endNode
    }
    
}
