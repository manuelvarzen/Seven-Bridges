//
//  Path.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 11/21/17.
//

import Foundation

class Path {
    
    var edges: [Edge]!
    
    var origin: Node? {
        return edges.first?.startNode
    }
    
    var target: Node? {
        return edges.last?.endNode
    }
    
    var length: Int {
        return edges.count + 1
    }
    
    var weight: Int {
        var w = 0
        
        for edge in edges {
            w += edge.weight
        }
        
        return w
    }
    
    init(_ array: [Edge] = [Edge]()) {
        self.edges = array
    }
    
    func append(_ edge: Edge) {
        edges.append(edge)
    }
    
    func outline(duration: Int? = nil, delay: Int = 0) {
        for (index, edge) in edges.enumerated() {
            let deadline = delay + index
            
            let startNode = edge.startNode
            let endNode = edge.endNode
            
            // highlight nodes after 'index' seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(deadline), execute: {
                startNode?.isHighlighted = true
                endNode?.isHighlighted = true
                
                edge.isHighlighted = true
            })
            
            // unhighlight node after set duration
            if duration != nil {
                let runtime = delay + duration!
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(runtime), execute: {
                    startNode?.isHighlighted = false
                    endNode?.isHighlighted = false
                    
                    edge.isHighlighted = false
                })
            }
        }
    }
}
