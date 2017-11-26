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
    
    @IBOutlet weak var edgeWeightPlusButton: UIBarButtonItem!
    
    @IBOutlet weak var edgeWeightMinusButton: UIBarButtonItem!
    
    @IBOutlet weak var edgeWeightIndicator: UIBarButtonItem!
    
    @IBOutlet weak var removeEdgeButton: UIBarButtonItem!
    
    @IBOutlet var graph: Graph!
    
    @IBAction func increaseSelectedEdgeWeight(_ sender: UIBarButtonItem) {
        graph.shiftSelectedEdgeWeight(by: 1)
    }
    
    @IBAction func decreaseSelectedEdgeWeight(_ sender: UIBarButtonItem) {
        graph.shiftSelectedEdgeWeight(by: -1)
    }
    
    @IBAction func removeSelectedEdge(_ sender: UIBarButtonItem) {
        graph.removeSelectedEdge()
    }
    
    @IBAction func deleteSelectedNodes(_ sender: UIBarButtonItem) {
        graph.deleteSelectedNodes()
    }
    
    @IBAction func enterSelectMode(_ sender: UIBarButtonItem) {
        if graph.mode != .select && graph.mode != .viewOnly {
            // tapping "Select"
            graph.mode = .select
            
            sender.title = "Done"
            sender.style = .done
            
            nodesModeButton.isEnabled = false
            edgesModeButton.isEnabled = false
        } else {
            // tapping "Done"
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
    
    @IBAction func openActionsPopover(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let actionsVC = storyboard.instantiateViewController(withIdentifier: "actionsViewController")
        actionsVC.modalPresentationStyle = .popover
        actionsVC.popoverPresentationController?.barButtonItem = sender
        
        (actionsVC as? ActionsController)?.viewControllerDelegate = self
        
        present(actionsVC, animated: true)
    }
    
    @IBAction func clearGraph(sender: UIBarButtonItem) {
        graph.clear()
    }
    
    func didSelectAction(_ action: String, from viewController: UIViewController) {
        viewController.dismiss(animated: false, completion: nil)
        
        switch action {
        case "Toggle Direction":
            graph.isDirected = !graph.isDirected
        case "Minimum Spanning Tree (Kruskal)":
            graph.kruskalMinimumSpanningTree()
        case "Minimum Spanning Tree (Prim)":
            graph.primMinimumSpanningTree()
        case "Find Shortest Path (Dijkstra)":
            graph.shortestPath()
        case "Renumber Nodes":
            graph.renumberNodes()
        case "Reset Edge Weights":
            graph.resetAllEdgeWeights()
        case "Remove All Edges":
            graph.removeAllEdges()
        default:
            print("An unexpected error occurred.")
        }
    }
    
}

