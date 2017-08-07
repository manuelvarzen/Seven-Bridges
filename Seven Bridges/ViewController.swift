//
//  ViewController.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//

import UIKit

class ViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        graph.propertiesToolbar = propertiesToolbar
    }
    
    @IBOutlet weak var propertiesToolbar: UIToolbar!
    
    @IBOutlet var graph: Graph!
    
    @IBAction func deleteSelectedNodes(_ sender: UIBarButtonItem) {
        graph.deleteSelectedNodes()
    }
    
    @IBAction func findShortestPath(_ sender: UIBarButtonItem) {
        graph.shortestPath()
    }
    
    @IBAction func renumberNodes(_ sender: UIBarButtonItem) {
        graph.renumberNodes()
    }
    
    @IBAction func enterNodesMode(_ sender: UIBarButtonItem) {
        graph.mode = .nodes
    }
    
    @IBAction func enterEdgesMode(_ sender: UIBarButtonItem) {
        graph.mode = .edges
    }
    
    @IBAction func clearGraph(sender: UIBarButtonItem) {
        graph.clear()
    }
    
}

