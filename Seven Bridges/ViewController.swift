//
//  ViewController.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var graphView: GraphView!
    
    @IBAction func enableDragging(_ sender: UIBarButtonItem) {
        graphView.mode = GraphView.Mode.dragging
    }
    
    @IBAction func makeNodes(_ sender: UIBarButtonItem) {
        graphView.mode = GraphView.Mode.nodes
    }
    
    @IBAction func makeEdges(_ sender: UIBarButtonItem) {
        graphView.mode = GraphView.Mode.edges
    }
    
    @IBAction func clearGraph(sender: UIBarButtonItem) {
        graphView.clear()
    }
    
}

