//
//  AccessoryTableViewController.swift
//  AccessorizeMe
//
//  Created by Andi Maroge on 1/17/19.
//  Copyright © 2019 Andi Maroge. All rights reserved.
//

import UIKit

class AccessoryTableViewController: UITableViewController {

    
    
    lazy var accessoryTableViewModel = AccessoryTableViewModel()
    var accessoryTableViewDocument: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        accessoryTableViewDocument = accessoryTableViewModel.accessoryImagesSubPaths
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return accessoryTableViewDocument!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessoryCell", for: indexPath)
            cell.textLabel?.text = accessoryTableViewDocument![indexPath.row]
        
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: indexPath)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "detailSegue":
            if let indexPath = sender as? IndexPath,
        let segueToMVC = segue.destination as? AccessoryArtViewController{
            segueToMVC.accessorySubPath = accessoryTableViewDocument![indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            
            toggleAnimatedHiddenSplitViewController()
//            segueToMVC.updateCollectionViewAfterSeque()
           
            }
        default: break
        }
    }
   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UITableViewController {
    func toggleAnimatedHiddenSplitViewController() {
        if view.traitCollection.userInterfaceIdiom == .pad && splitViewController?.displayMode == .primaryOverlay {
            let animations: () -> Void = {
                self.splitViewController?.preferredDisplayMode = .primaryHidden
            }
            let completion: (Bool) -> Void = { _ in
                self.splitViewController?.preferredDisplayMode = .automatic
            }
            UIView.animate(withDuration: 0.1, animations: animations, completion: completion)
        }
    }
}
