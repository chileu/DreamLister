//
//  MainVC.swift
//  DreamLister
//
//  Created by Chi-Ying Leung on 3/29/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    // need to specify what entity you are working with (Item)
    var controller: NSFetchedResultsController<Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        attemptFetch()

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func attemptFetch() {
        
        // create a fetch request. Item.fetchRequest() tells FRC to fetch results from Item entity
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()

        
        // tells FRC how to sort data that it's fetching
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
       
        let typeSort = NSSortDescriptor(key: "toItemType.type", ascending: true)
        
        
        if segment.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        } else if segment.selectedSegmentIndex == 3 {
            fetchRequest.sortDescriptors = [typeSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        // this is the attempt to fetch data function. it can throw an error so it's wrapped in a do-catch
        // performFetch() is called on the controller to actually execute the fetch
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    // FRC is about to start processing changes due to add, move, update, or delete
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        // Begins a series of method calls that insert, delete, or select rows and sections of the table view. Call this method if you want subsequent insertions, deletion, and selection operations to be animated simultaneously.
        
        tableView.beginUpdates()
    }
    
    // FRC has completed processing changes due to add, move, update, or delete
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }
    
    // listens for when we make changes, such as insert, delete, move, update
    // didChange anObject function
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        // write code to deal with all cases on the type
        switch(type) {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
            
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    
    func generateTestData() {
        let item = Item(context: context)
        item.title = "Chanel Classic Bag with Gold Chain"
        item.price = 3400
        item.details = "Vintage Black Quilted Lambskin Classic Flap Medium"
        let picture = Image(context: context)
        picture.image = UIImage(named: "chanel")
        item.toImage = picture
        
        
        let item2 = Item(context: context)
        item2.title = "Chanel Red Caviar Bag"
        item2.price = 3950
        item2.details = "Vintage Red Caviar Supermodel Small"
        let picture2 = Image(context: context)
        picture2.image = UIImage(named: "chanel2")
        item2.toImage = picture2
        
        let item3 = Item(context: context)
        item3.title = "Chanel Purple Iridescent Bag"
        item3.price = 3995
        item3.details = "Vintage Purple Iridescent Caviar Flap Jumbo"
        let picture3 = Image(context: context)
        picture3.image = UIImage(named: "chanel3")
        item3.toImage = picture3
        
        let item4 = Item(context: context)
        item4.title = "Ronny Kobo Flared Dress"
        item4.price = 159
        item4.details = "A-line knit dress in black and white"
        let picture4 = Image(context: context)
        picture4.image = UIImage(named: "dress")
        item4.toImage = picture4
        
        ad.saveContext()
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        attemptFetch()
        tableView.reloadData()
        
    }
    
    
    
}

