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
        graph.assignViewController(self)
    }
    
    @IBOutlet weak var selectModeButton: UIBarButtonItem!
    
    @IBOutlet weak var nodesModeButton: UIBarButtonItem!
    
    @IBOutlet weak var edgesModeButton: UIBarButtonItem!
    
    @IBOutlet weak var renumberNodesButton: UIBarButtonItem!
    
    @IBOutlet weak var findShortestPathButton: UIBarButtonItem!
    
    @IBOutlet weak var mainToolbar: UIToolbar!
    
    @IBOutlet weak var propertiesToolbar: UIToolbar!
    
    @IBOutlet weak var edgeWeightButton: UIBarButtonItem!
    
    @IBOutlet weak var removeEdgeButton: UIBarButtonItem!
    
    @IBOutlet var graph: Graph!
    
    @IBAction func editSelectedEdgeWeight(_ sender: UIBarButtonItem) {
        graph.editSelectedEdgeWeight()
    }
    
    @IBAction func removeSelectedEdge(_ sender: UIBarButtonItem) {
        graph.removeSelectedEdge()
    }
    
    @IBAction func deleteSelectedNodes(_ sender: UIBarButtonItem) {
        graph.deleteSelectedNodes()
    }
    
    @IBAction func findShortestPath(_ sender: UIBarButtonItem) {
        graph.shortestPath()
    }
    
    @IBAction func renumberNodes(_ sender: UIBarButtonItem) {
        graph.renumberNodes()
    }
    
    @IBAction func enterSelectMode(_ sender: UIBarButtonItem) {
        if graph.mode != .select {
            graph.mode = .select
            
            sender.title = "Done"
            sender.style = .done
            
            // Disable all other buttons
            for item in mainToolbar.items! {
                if item != sender {
                    item.isEnabled = false
                }
            }
        } else {
            graph.deselectNodes()
            graph.mode = .nodes
            
            sender.title = "Select"
            sender.style = .plain
            
            // Enable all the buttons
            for item in mainToolbar.items! {
                if item != sender {
                    item.isEnabled = true
                }
            }
        }
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

