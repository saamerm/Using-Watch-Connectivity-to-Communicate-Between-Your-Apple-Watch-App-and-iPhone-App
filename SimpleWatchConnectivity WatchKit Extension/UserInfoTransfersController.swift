/*
See LICENSE folder for this sample’s licensing information.

Abstract:
UserInfoTransfersController manages outstanding user info transfers.
*/

import Foundation
import WatchKit
import WatchConnectivity

extension ControllerID {
    static let userInfoTransfersController = "UserInfoTransfersController"
    static let userInfoTransferRowController = "UserInfoTransferRowController"
    static let doneRowController = "DoneRowController"
}

class UserInfoTransfersController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    var rowType: String {
        return ControllerID.userInfoTransferRowController
    }

    var command: Command!
    
    // Outstanding transfers can change in the background so make a copy (cache) to
    // make sure the data doesn't change during the table loading cycle.
    // Subclasses can override the computed property to provide the right transfers.
    //
    var transfersStore: [SessionTransfer]?
    var transfers: [SessionTransfer] {
        if transfersStore == nil {
            transfersStore = WCSession.default.outstandingUserInfoTransfers
        }
        return transfersStore!
    }
    
    // Load the table. Show the "Done" row if there isn't any outstanding transfers.
    //
    func loadTable() {
        guard !transfers.isEmpty else {
            table.setNumberOfRows(1, withRowType: ControllerID.doneRowController)
            return
        }
        
        table.setNumberOfRows(transfers.count, withRowType: rowType)

        for (index, transfer) in transfers.enumerated() {
            if let row = table.rowController(at: index) as? UserInfoTransferRowController {
                row.update(with: transfer)
            }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let aCommand = context as? Command else {
            fatalError("Invalid context for presenting this controller!")
        }
        command = aCommand
        loadTable()
    }

    override func willActivate() {
        super.willActivate()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).dataDidFlow(_:)),
            name: .dataDidFlow, object: nil
        )
    }

    override func didDeactivate() {
        super.didDeactivate()
        NotificationCenter.default.removeObserver(self, name: .dataDidFlow, object: nil)
    }
    
    // Cancel the transfer when the table row is selected.
    //
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if rowIndex >= transfers.count {
            print("Selected row has been removed! Current transfers: \(transfers)")
            return
        }
        let transfer = transfers[rowIndex]
        transfer.cancel(notifying: command)
    }

    // .dataDidFlow notification handler. Update the UI the notification object.
    //
    @objc
    func dataDidFlow(_ notification: Notification) {
        guard let commandStatus = notification.object as? CommandStatus else { return }
        guard commandStatus.command == command, commandStatus.phrase != .failed else { return }
        
        transfersStore = nil
        loadTable()
    }
}

class UserInfoTransferRowController: NSObject {
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var deleteLabel: WKInterfaceLabel!
    
    // Update the table cell with the transfer's timed color.
    //
    func update(with transfer: SessionTransfer) {
        titleLabel.setText(transfer.timedColor.timeStamp)
        titleLabel.setTextColor(transfer.timedColor.color)
    }

}

class DoneRowController: NSObject {
    @IBOutlet var doneLabel: WKInterfaceLabel!
}
