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
    
    @IBAction func enterSelectMode(_ sender: UIBarButtonItem) {
        if graph.mode != .select {
            graph.mode = .select
            
            sender.title = "Done"
            sender.style = .done
            
            nodesModeButton.isEnabled = false
            edgesModeButton.isEnabled = false
        } else {
            graph.deselectNodes(unhighlight: true)
            graph.mode = .nodes
            
            sender.title = "Select"
            sender.style = .plain
            
            nodesModeButton.isEnabled = true
            edgesModeButton.isEnabled = true
        }
    }
    
    @IBAction func enterNodesMode(_ sender: UIBarButtonItem) {
        graph.mode = .nodes
    }
    
    @IBAction func enterEdgesMode(_ sender: UIBarButtonItem) {
        graph.mode = .edges
    }
    
    @IBAction func openAlgorithmsPopover(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let algorithmsVC = storyboard.instantiateViewController(withIdentifier: "algorithmsViewController")
        algorithmsVC.modalPresentationStyle = .popover
        algorithmsVC.popoverPresentationController?.barButtonItem = sender
        
        (algorithmsVC as? ActionsController)?.viewControllerDelegate = self
        
        present(algorithmsVC, animated: true)
    }
    
    @IBAction func clearGraph(sender: UIBarButtonItem) {
        graph.clear()
    }
    
    func didSelectAction(_ algorithm: String, from viewController: UIViewController) {
        viewController.dismiss(animated: false, completion: nil)
        
        switch algorithm {
        case "Toggle Direction":
            graph.isDirected = !graph.isDirected
        case "Minimum Spanning Tree (Kruskal)":
            graph.kruskal()
        case "Minimum Spanning Tree (Prim)":
            graph.prim()
        case "Find Shortest Path (Dijkstra)":
            graph.findShortestPath()
        case "Renumber Nodes":
            graph.renumberNodes()
        default:
            print("An unexpected error occurred.")
        }
    }
    
}

