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
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    
    private var defaultToolbarItems: [UIBarButtonItem]!
    
    private var selectingToolbarItems: [UIBarButtonItem]!
    
    override func viewDidLoad() {
        // Save the default toolbar items.
        defaultToolbarItems = toolbar.items!
        
        // Create the delete button.
        let deleteButton = UIBarButtonItem()
        deleteButton.title = "Delete"
        deleteButton.action = #selector(deleteSelectedNodes)
        
        // Create the shortest path button.
        let shortestPathButton = UIBarButtonItem()
        shortestPathButton.title = "Shortest Path"
        shortestPathButton.action = #selector(shortestPath)
        //shortestPathButton.isEnabled = false
        
        selectingToolbarItems = [UIBarButtonItem]()
        selectingToolbarItems.append(deleteButton)
        selectingToolbarItems.append(shortestPathButton)
    }
    
    @objc func deleteSelectedNodes() {
        graphView.deleteSelectedNodes()
    }
    
    @objc func shortestPath() {
        graphView.shortestPath()
        
        enterDefaultMode(with: .dragging)
    }
    
    @IBAction func enableSelecting(_ sender: UIBarButtonItem) {
        if graphView.mode != .selecting {
            enterSelectingMode()
        } else {
            enterDefaultMode(with: .dragging)
        }
    }
    
    @IBAction func numberize(_ sender: UIBarButtonItem) {
        graphView.renumberNodes()
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
    
    private func enterSelectingMode() {
        graphView.mode = .selecting
        
        selectButton.title = "Done"
        selectButton.style = UIBarButtonItemStyle.done
        
        toolbar.items = selectingToolbarItems
    }
    
    private func enterDefaultMode(with mode: Graph.Mode) {
        graphView.mode = mode
        graphView.deselectNodes()
        
        selectButton.title = "Select..."
        selectButton.style = UIBarButtonItemStyle.plain
        
        toolbar.items = defaultToolbarItems
    }
    
}

