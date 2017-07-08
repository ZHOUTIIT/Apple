//
//  ViewController.swift
//  testTable
//
//  Created by Zhou Ti on 7/7/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var moc: NSManagedObjectContext!

    var messageArray = [Content]()

    @IBOutlet weak var table: UITableView!

    @IBAction func add(_ sender: UIBarButtonItem) {
        let board = storyboard?.instantiateViewController(withIdentifier: "addContent") as! addContentViewController
        present(board, animated: true, completion: nil)
    }

    func loadData() {
        messageArray = [Content]()
        let sort = NSSortDescriptor(key: "date", ascending: true)
        messageArray = SwiftCoreDataHelper.fetchEntities(className: "Content" as NSString, withPredict: nil, andSortDescriptor: sort, managedObjectContext: moc) as! [Content]
        table.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name(rawValue: "newcontent"), object: nil)
        table.delegate = self
        table.dataSource = self
        moc = SwiftCoreDataHelper.manageObjectContext()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }

    @IBAction func edit(_ sender: UIBarButtonItem) {
        table.isEditing = !table.isEditing
    }
    func update(info: Notification) {
        let messageObject = SwiftCoreDataHelper.insertManagedObject(className: "Content" as NSString, managedObjectContext: moc) as! Content
        let msg = info.userInfo?["content"]
        messageObject.message = msg as? String
        messageObject.date = NSDate()
        let _ = SwiftCoreDataHelper.saveManagedObjectContext(managedObjectContext: self.moc)
        DispatchQueue.main.async(execute: {
            self.loadData()
        })

    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let object = messageArray[indexPath.row] as NSManagedObject
            let _ = SwiftCoreDataHelper.deleteManagedObjectContext(managedObjectContext: self.moc, managedObject: object)
            loadData()
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceDate = messageArray[sourceIndexPath.row].date
        let destDate = messageArray[destinationIndexPath.row].date
        SwiftCoreDataHelper.setValueForManagedObject(managedObject: messageArray[sourceIndexPath.row] as NSManagedObject, key: "date", value: destDate!)
        SwiftCoreDataHelper.setValueForManagedObject(managedObject: messageArray[destinationIndexPath.row] as NSManagedObject, key: "date", value: sourceDate!)

    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let messageObject = messageArray[indexPath.row]
        cell.content.text = messageObject.message
        return cell
    }
}
