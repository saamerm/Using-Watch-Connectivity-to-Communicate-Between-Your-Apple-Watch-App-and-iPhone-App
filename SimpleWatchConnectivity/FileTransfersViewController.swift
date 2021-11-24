/*
See LICENSE folder for this sample’s licensing information.

Abstract:
FileTransfersViewController manages the file transfer of the iOS app.
*/

import UIKit
import WatchConnectivity

class FileTransfersViewController: UserInfoTransfersViewController {
    
    // Hold the file transfer observers to keep observing the progress.
    //
    private var fileTransferObservers = FileTransferObservers()
 
    // Rebuild the fileTransferObservers every time transfersStore is rebuilt.
    //
    override var transfers: [SessionTransfer] {
        guard transfersStore == nil else { return transfersStore! }
        
        fileTransferObservers = FileTransferObservers()
        
        let fileTransfers = WCSession.default.outstandingFileTransfers
        transfersStore = fileTransfers
        
        // Observing handler can be called from background so dispatch
        // the UI update code to main queue and use the table data at the moment.
        //
        for transfer in fileTransfers {
            fileTransferObservers.observe(transfer) { progress in
                DispatchQueue.main.async {
                    guard let index = self.transfers.index(where: {
                        ($0 as? WCSessionFileTransfer)?.progress === progress }) else { return }
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    if let cell = self.tableView.cellForRow(at: indexPath) {
                        cell.detailTextLabel?.text = progress.localizedDescription
                    }
                }
            }
        }
        return transfersStore!
    }
    
    // Upate the detailed text label in the table cell with progress when the table is reloading.
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let transfer = transfers[indexPath.row] as? WCSessionFileTransfer {
            cell.detailTextLabel?.text = transfer.progress.localizedDescription
        }
        
        return cell
    }
}
