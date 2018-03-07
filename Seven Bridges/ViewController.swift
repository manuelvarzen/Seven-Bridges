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
        graph.parentVC = self
    }
    
    @IBOutlet weak var selectModeButton: UIBarButtonItem!
    
    @IBOutlet weak var nodesModeButton: UIBarButtonItem!
    
    @IBOutlet weak var edgesModeButton: UIBarButtonItem!
    
    @IBOutlet weak var actionsMenuButton: UIBarButtonItem!
    
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
    
    /// Called when the selectModeButton is tapped.
    @IBAction func selectButtonTapped(_ sender: UIBarButtonItem) {
        if graph.mode != .select && graph.mode != .viewOnly {
            enterSelectMode(sender)
        } else {
            exitSelectMode(sender)
        }
    }
    
    /// Puts the graph in select mode and updates the selectModeButton.
    func enterSelectMode(_ sender: UIBarButtonItem) {
        graph.mode = .select
        
        sender.title = "Done"
        sender.style = .done
        
        nodesModeButton.isEnabled = false
        edgesModeButton.isEnabled = false
    }
    
    func exitSelectMode(_ sender: UIBarButtonItem, graphWasJustCleared: Bool = false) {
        if !graphWasJustCleared {
            graph.deselectNodes(unhighlight: true, resetEdgeProperties: true)
        }
        
        graph.mode = .nodes
        
        sender.title = "Select"
        sender.style = .plain
        
        // re-enable toolbar buttons
        nodesModeButton.isEnabled = true
        edgesModeButton.isEnabled = true
        
        // actionsMenuButton is disabled from the graph after running an algorithm
        // therefore, undo
        graph.justRanAlgorithm = false
    }
    
    @IBAction func enterNodesMode(_ sender: UIBarButtonItem) {
        graph.mode = .nodes
    }
    
    @IBAction func enterEdgesMode(_ sender: UIBarButtonItem) {
        graph.mode = .edges
    }
    
    @IBAction func openActionsPopover(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let actionsVC = storyboard.instantiateViewController(withIdentifier: "actionsViewController") as! ActionsController
        actionsVC.modalPresentationStyle = .popover
        actionsVC.popoverPresentationController?.barButtonItem = sender
        actionsVC.graph = graph
        actionsVC.viewControllerDelegate = self
        
        present(actionsVC, animated: true)
    }
    
    @IBAction func clearGraph(sender: UIBarButtonItem) {
        // prompt user before clearing graph
        Announcement.new(title: "Clear Graph", message: "Are you sure you want to clear the graph?", action: { (action: UIAlertAction!) -> Void in
            self.graph.clear()
            self.exitSelectMode(self.selectModeButton, graphWasJustCleared: true)
        }, cancelable: true)
    }
}

