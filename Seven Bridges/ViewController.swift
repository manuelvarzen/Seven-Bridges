//
//  ViewController.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var graphView: GraphView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    private var defaultToolbarItems: [UIBarButtonItem]!
    
    private var selectingToolbarItems: [UIBarButtonItem]!
    
    override func viewDidLoad() {
        // Save the default toolbar items.
        defaultToolbarItems = toolbar.items!
        
        // Create the delete button.
        let deleteButton = UIBarButtonItem()
        deleteButton.title = "Delete"
        deleteButton.action = #selector(deleteSelectedNodes)
        
        selectingToolbarItems = [UIBarButtonItem]()
        selectingToolbarItems.append(deleteButton)
    }
    
    @objc func deleteSelectedNodes() {
        graphView.deleteSelectedNodes()
    }
    
    @IBAction func enableSelecting(_ sender: UIBarButtonItem) {
        if graphView.mode != .selecting {
            graphView.mode = GraphView.Mode.selecting
        } else {
            graphView.mode = GraphView.Mode.dragging
        }
        
        if graphView.mode == .selecting {
            sender.title = "Done"
            sender.style = UIBarButtonItemStyle.done
            toolbar.items = selectingToolbarItems
        } else {
            sender.title = "Select"
            sender.style = UIBarButtonItemStyle.plain
            toolbar.items = defaultToolbarItems
            
            graphView.deselectNodes()
        }
    }
    
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

