//
//  ViewController.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var graphView: Graph!
    
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
            graphView.mode = Graph.Mode.selecting
        } else {
            graphView.mode = Graph.Mode.dragging
        }
        
        if graphView.mode == .selecting {
            sender.title = "Done"
            sender.style = UIBarButtonItemStyle.done
            toolbar.items = selectingToolbarItems
        } else {
            sender.title = "Select..."
            sender.style = UIBarButtonItemStyle.plain
            toolbar.items = defaultToolbarItems
            
            graphView.deselectNodes()
        }
    }
    
    @IBAction func numberize(_ sender: UIBarButtonItem) {
        graphView.numberize()
    }
    
    @IBAction func colorize(_ sender: UIBarButtonItem) {
        graphView.colorize()
    }
    
    @IBAction func enableDragging(_ sender: UIBarButtonItem) {
        graphView.mode = Graph.Mode.dragging
    }
    
    @IBAction func makeNodes(_ sender: UIBarButtonItem) {
        graphView.mode = Graph.Mode.nodes
    }
    
    @IBAction func makeEdges(_ sender: UIBarButtonItem) {
        graphView.mode = Graph.Mode.edges
    }
    
    @IBAction func clearGraph(sender: UIBarButtonItem) {
        graphView.clear()
    }
    
}

