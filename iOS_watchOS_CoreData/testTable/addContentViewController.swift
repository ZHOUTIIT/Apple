//
//  addContentViewController.swift
//  testTable
//
//  Created by Zhou Ti on 7/7/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import CoreData

//protocol AddContent {
//    func addcontent(string: String)
//}

class addContentViewController: UIViewController {


    var moc : NSManagedObjectContext!

    @IBOutlet weak var content: UITextField!
//    var addcontentProtocol : AddContent!
    override func viewDidLoad() {
        super.viewDidLoad()
        moc = SwiftCoreDataHelper.manageObjectContext()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done(_ sender: UIBarButtonItem) {
//        addcontentProtocol.addcontent(string: content.text!)
        let messageObject = SwiftCoreDataHelper.insertManagedObject(className: "Content" as NSString, managedObjectContext: moc) as! Content
        messageObject.message = content.text
        messageObject.date = NSDate()
        let _ = SwiftCoreDataHelper.saveManagedObjectContext(managedObjectContext: self.moc)
        dismiss(animated: true, completion: nil)
    }

}
