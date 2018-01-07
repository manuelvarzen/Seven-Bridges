//
//  Path.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 11/21/17.
//

import Foundation

class Path {
    
    /// All nodes that make up the path.
    var nodes: [Node]!
    
    /// All edges that make up the path.
    var edges: [Edge]!
    
    /// First node in the path.
    var first: Node? {
        return nodes.first
    }
    
    /// Last node in the path.
    var last: Node? {
        return nodes.last
    }
    
    /// Number of nodes in the path (number of edges + 1).
    var length: Int {
        return nodes.count
    }
    
    /// Aggregate weight of all edges in the path.
    var weight: Int {
        var w = 0
        
        for edge in edges {
            w += edge.weight
        }
        
        return w
    }
    
    /// Whether the path is a loop (starting node is the same as the last).
    var isLoop: Bool {
        if first == last {
            return true
        } else {
            return false
        }
    }
    
    init(_ edges: [Edge] = [Edge]()) {
        self.edges = edges
        
        nodes = [Node]()
        
        for edge in edges {
            nodes.append(edge.startNode)
            
            if edge == edges.last {
                nodes.append(edge.endNode)
            }
        }
    }
    
    init(_ nodes: [Node]) {
        var edges = [Edge]()
        
        for (i, _) in nodes.enumerated() {
            if i < nodes.count - 1 {
                let commonEdge = nodes[i].edges.union(nodes[i + 1].edges).first
                
                if commonEdge != nil {
                    edges.append(commonEdge!)
                }
            }
        }
        
        self.nodes = nodes
        self.edges = edges
    }
    
    /// Appends a new edge to the path, given a node.
    ///
    /// - parameter node: A node adjacent to the last node in the path.
    ///
    func append(_ node: Node) {
        nodes.append(node)
        
        if nodes.count > 1 {
            let secondLastNode = nodes[nodes.count - 2]
            let commonEdges = secondLastNode.edges.union(node.edges)
            
            for edge in commonEdges {
                if edge.startNode == secondLastNode && edge.endNode == node {
                    edges.append(edge)
                    break
                }
            }
        }
    }
    
    /// Appends a new edge to the path.
    ///
    /// - parameter edge: The edge to be appended.
    ///
    func append(_ edge: Edge) {
        edges.append(edge)
        
        if edge.startNode != nodes.last {
            nodes.append(edge.startNode)
        }
        
        nodes.append(edge.endNode)
    }
    
    /// Appends a new edge to the path, given two nodes.
    ///
    /// - parameter from: A node at one end of the edge.
    /// - parameter to: Another node at the other end of the edge.
    ///
    func append(from startNode: Node, to endNode: Node) {
        let commonEdge = startNode.edges.union(endNode.edges).first
        
        if commonEdge != nil {
            append(commonEdge!)
        }
    }
    
    /// Determines whether a node is in the path.
    ///
    /// - parameter node: The node being searched for in the path.
    ///
    func contains(_ node: Node) -> Bool {
        for edge in edges {
            if edge.startNode == node || edge.endNode == node {
                return true
            }
        }
        
        return false
    }
    
    /// Outlines the path, including nodes and edges.
    ///
    /// - parameter duration: The total duration of the outlining.
    /// - parameter delay: The delay, in seconds, between the highlighting of each node in the path.
    ///
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
