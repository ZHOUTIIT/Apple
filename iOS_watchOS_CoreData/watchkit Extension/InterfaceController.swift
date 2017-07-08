//
//  InterfaceController.swift
//  watchkit Extension
//
//  Created by Zhou Ti on 8/7/17.
//  Copyright © 2017 com. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    var index = 0
    let session = WCSession.default()

    @IBAction func send() {
        session.sendMessage(["content": "new message \(index)"], replyHandler: nil, errorHandler: nil)
        index += 1
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
