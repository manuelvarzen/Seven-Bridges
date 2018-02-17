//
//  Path.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 11/21/17.
//

import UIKit

class Path: CustomStringConvertible {
    
    /// All nodes that make up the path.
    var nodes = [Node]()
    
    /// All edges that make up the path.
    var edges = [Edge]()
    
    /// First node in the path.
    var first: Node? {
        return nodes.first
    }
    
    /// Last node in the path.
    var last: Node? {
        return nodes.last
    }
    
    /// Aggregate weight of all edges in the path.
    var weight: Int {
        var w = 0
        
        for edge in edges {
            w += edge.weight
        }
        
        return w
    }
    
    /// Total residual capacity of the edges in the path.
    var residualCapacity: Int? {
        var residuals = [Int]()
        edges.forEach({
            residuals.append($0.residualCapacity!)
        })
        
        return residuals.min()
    }
    
    /// Total flow in the path.
    var flow: Int? {
        var totalFlow = 0
        edges.forEach({
            if let f = $0.flow {
                totalFlow += f
            }
        })
        
        return totalFlow
    }
    
    /// Whether the path is a loop (starting node is the same as the last).
    var isLoop: Bool {
        if first == last {
            return true
        } else {
            return false
        }
    }
    
    /// String representation of the path as a sequence of nodes.
    var description: String {
        var string = ""
        
        for node in nodes {
            string += node.description
            
            if node != nodes.last! {
                string += " → "
            }
        }
        
        return string
    }
    
    init(_ path: Path) {
        self.nodes = path.nodes
        self.edges = path.edges
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
        self.nodes = nodes
        
        edges = [Edge]()
        
        for (i, _) in nodes.enumerated() {
            if i < nodes.count - 1 {
                if let commonEdge = nodes[i].edges.union(nodes[i + 1].edges).first {
                    edges.append(commonEdge)
                }
            }
        }
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
    func append(_ edge: Edge, ignoreNodes: Bool = false) {
        edges.append(edge)
        
        if edge.startNode != nodes.last && !ignoreNodes {
            nodes.append(edge.startNode)
        }
        
        if !ignoreNodes {
            nodes.append(edge.endNode)
        }
    }
    
    /// Appends a new edge to the path, given two nodes.
    ///
    /// - parameter from: A node at one end of the edge.
    /// - parameter to: Another node at the other end of the edge.
    ///
    func append(from startNode: Node, to endNode: Node) {
        if let commonEdge = startNode.edges.union(endNode.edges).first {
            append(commonEdge)
        }
    }
    
    /// Determines whether a node is in the path.
    ///
    /// - parameter node: The node being searched for in the path.
    ///
    func contains(_ node: Node) -> Bool {
        return nodes.contains(node)
    }
    
    /// Returns the parent of a given node in the path.
    ///
    /// - parameter of: A node in the path.
    ///
    func parent(of node: Node) -> Node? {
        if let index = nodes.index(of: node) {
            if index > 0 {
                return nodes[index - 1]
            }
        }
        
        return nil
    }
    
    /// Returns an edge in the path between two given nodes.
    ///
    /// - parameter from: The start node of the edge.
    /// - parameter to: The end node of the edge.
    ///
    func edge(from a: Node, to b: Node) -> Edge? {
        return edges.first(where: { $0.startNode! == a && $0.endNode! == b })
    }
    
    /// Outlines the path by highlighting all nodes and edges.
    ///
    /// - parameter duration: The total duration of the outlining. If nil, outlining does not expire.
    /// - parameter wait: How many seconds to wait before outlining.
    /// - parameter color: The color the path will be outlined with. Defaults to black.
    ///
    func outline(duration: Int? = nil, wait: Int = 0, color: UIColor = UIColor.black) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(wait), execute: {
            self.nodes.forEach({ node in
                node.highlighted(color: color)
            })
            
            self.edges.forEach({ edge in
                edge.highlighted(color: color)
            })
        })
        
        if duration != nil {
            let completionTime = wait + duration!
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(completionTime), execute: {
                self.nodes.forEach({ node in
                    node.highlighted(false)
                })
                
                self.edges.forEach({ edge in
                    edge.highlighted(false)
                })
            })
        }
    }
}
