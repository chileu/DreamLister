//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Chi-Ying Leung on 3/29/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImg: UIImageView!
    
    var stores = [Store]()
    var types = [ItemType]()
    
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        picker.delegate = self
        picker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //generateTestDataForStore()
        //generateTestDataForItemType()
        getStores()
        getItemTypes()
        
        if itemToEdit != nil {
            loadItemData()
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let store = stores[row]
            return store.name
        } else {
            let itemType = types[row]
            return itemType.type
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return stores.count
        } else {
            return types.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func generateTestDataForStore() {
        let store = Store(context: context)
        store.name = "Bloomingdales"
        let store2 = Store(context: context)
        store2.name = "Gilt"
        let store3 = Store(context: context)
        store3.name = "Saks Fifth Avenue"
        let store4 = Store(context: context)
        store4.name = "Net-A-Porter"
        let store5 = Store(context: context)
        store5.name = "Neiman Marcus"
        let store6 = Store(context: context)
        store6.name = "Tradesy"
        
        ad.saveContext()
    }
    
    func generateTestDataForItemType() {
        let itemType = ItemType(context: context)
        itemType.type = "Handbags"
        let itemType2 = ItemType(context: context)
        itemType2.type = "Shoes"
        let itemType3 = ItemType(context: context)
        itemType3.type = "Dresses"
        let itemType4 = ItemType(context: context)
        itemType4.type = "Pants"
        let itemType5 = ItemType(context: context)
        itemType5.type = "Tops"
        let itemType6 = ItemType(context: context)
        itemType6.type = "Skirts"
        
        ad.saveContext()
    }
    
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.picker.reloadAllComponents()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func getItemTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            self.types = try context.fetch(fetchRequest)
            self.picker.reloadAllComponents()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        
        let picture = Image(context: context)
        picture.image = thumbImg.image
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleField.text {
            item.title = title
        }
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsField.text {
            item.details = details
        }
        
        // we named our item-to-store relationship "toStore" but should have just called it 'store'
        // we are just setting the item's store to the selected store from the stores array. inComponent means section #
        
        item.toStore = stores[picker.selectedRow(inComponent: 0)]
        item.toItemType = types[picker.selectedRow(inComponent: 1)]
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            thumbImg.image = item.toImage?.image as? UIImage
            
            // if item has a store associated with it in CD,
            // loop through the array of all stores
            // and if it equals the store associated with the item
            // select that row in the picker for correct component
            // and break out of the while loop
            
            if let store  = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        picker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while index < stores.count
            }
            
            // same for item type
            if let itemType = item.toItemType {
                var index = 0
                repeat {
                    let t = types[index]
                    if t.type == itemType.type {
                        picker.selectRow(index, inComponent: 1, animated: false)
                        break
                    }
                    index += 1
                } while index < types.count
            }
            
        }
        
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
}
