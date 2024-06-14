//
//  SPDX-License-Identifier: MIT
//  https://github.com/jamf/CertificateSDK
//
//  Copyright 2024, Jamf
//
import UIKit

class SegmentedCellView: UITableViewCell {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
}

class ButtonCellView: UITableViewCell {
    @IBOutlet weak var button: UIButton!
}

class OptionCellView: UITableViewCell {
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var optionSwitch: UISwitch!

    override var detailTextLabel: UILabel? {
        return detailLabel
    }

    override var textLabel: UILabel? {
        return label
    }
}

class SetupTestViewController: UITableViewController {

    var detailViewController: ActionLogViewController?

    var testConfiguration = CertRequestConfiguration(isActual: false,
                                                     slowSpeed: true,
                                                     simulateError: false)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        if let split = splitViewController {
            let controllers = split.viewControllers
            let navController = controllers[controllers.count-1] as? UINavigationController
            detailViewController = navController?.topViewController as? ActionLogViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
            let navController = segue.destination as? UINavigationController,
            let controller = navController.topViewController as? ActionLogViewController {

            controller.testConfiguration = testConfiguration
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    // MARK: - Actions

    /// The user has switched which type of test they want to perform.
    ///
    /// - Parameter sender: The control that the user has switchde
    @IBAction func selectType(_ sender: UISegmentedControl) {
        let newActual = (sender.selectedSegmentIndex == 1)

        if newActual != testConfiguration.isActual {
            testConfiguration.isActual = newActual
            // reload the table with a nice animation.
            if let table = self.tableView {
                let rowsToAddOrDelete = [IndexPath(row: SetupRowIndices.optionSpeed.rawValue, section: 0),
                                         IndexPath(row: SetupRowIndices.optionError.rawValue, section: 0)]
                table.beginUpdates()
                table.reloadRows(at: [IndexPath(row: SetupRowIndices.descriptionOfTestType.rawValue, section: 0)],
                                 with: .fade)
                if testConfiguration.isActual {
                    table.deleteRows(at: rowsToAddOrDelete, with: .left)
                } else {
                    table.insertRows(at: rowsToAddOrDelete, with: .left)
                }
                table.endUpdates()
            }
        }
    }

    /// The user has turned on/off an option within the testConfiguration.
    ///
    /// - Parameter sender: The switch the user has toggled
    @IBAction func toggleOption(_ sender: UISwitch) {
        guard let index = SetupRowIndices(rawValue: sender.tag) else {
            // Some unknown option?
            return
        }

        switch index {
        case .optionSpeed:
            testConfiguration.slowSpeed = sender.isOn

        case .optionError:
            testConfiguration.simulateError = sender.isOn

        default:    // do nothing
            break
        }
    }

    /// User wants to schedule a notification for renewal.
    ///
    /// - Parameter _: Unused
    @IBAction func scheduleNotification(_ sender: UIButton) {
        let notificationService = LocalNotificationService.shared
        // A real app should schedule the notification to renew on some date in the future.
        notificationService.scheduleLocalNotificationForRenewal(Date(timeIntervalSinceNow: 60))

        // Let the user know it's scheduled.
        sender.setTitle("Scheduled", for: .normal)

        // Reset the title back to "Schedule Notification" after 4.5 seconds.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.5, qos: .background) {
            sender.setTitle("Schedule Notification", for: .normal)
        }
    }

    // MARK: - Table View

    private enum SetupRowIndices: Int {
        case typeOfTest
        case descriptionOfTestType
        case optionSpeed
        case optionError
        case runTestButton
        case descriptionOfNotification
        case scheduleNotification
    }
    private enum SetupNumberOfRows: Int {
        case simulatedTest = 7
        case actualTest = 5
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (testConfiguration.isActual ? SetupNumberOfRows.actualTest : SetupNumberOfRows.simulatedTest).rawValue
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let index = SetupRowIndices(rawValue: indexPath.row) else {
            // Some unknown row?
            return UITableViewCell()
        }

        return self.cell(for: index, at: indexPath)
    }

    private func cell(for index: SetupRowIndices, at indexPath: IndexPath) -> UITableViewCell {
        switch index {
        case .typeOfTest:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeSelection",
                                                     for: indexPath) as? SegmentedCellView

            cell?.segmentedControl.selectedSegmentIndex = (testConfiguration.isActual ? 1 : 0)
            return cell!
        case .descriptionOfTestType:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Description", for: indexPath)

            if testConfiguration.isActual {
                cell.textLabel!.text = "Makes the network calls to the Jamf Pro server to request a certificate"
            } else {
                cell.textLabel!.text = "Uses the embedded example .p12 for local testing"
            }
            return cell
        case .optionSpeed:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Option", for: indexPath) as? OptionCellView

            // This lets our action know which option is being switched on/off
            cell?.optionSwitch.tag = index.rawValue

            cell?.textLabel!.text = "Slow speed"
            cell?.detailTextLabel!.text = "Simulates a slow server"
            cell?.optionSwitch.isOn = testConfiguration.slowSpeed
            return cell!
        case .optionError:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Option", for: indexPath) as? OptionCellView

            // This lets our action know which option is being switched on/off
            cell?.optionSwitch.tag = index.rawValue

            cell?.textLabel!.text = "Error simulation"
            cell?.detailTextLabel!.text = "Results in an error"
            cell?.optionSwitch.isOn = testConfiguration.simulateError
            return cell!
        case .runTestButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RunTest", for: indexPath)
            return cell
        case .descriptionOfNotification:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Description", for: indexPath)

            cell.textLabel?.text = "Schedule a local notification to renew the certificate in five seconds"
            return cell
        case .scheduleNotification:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RunTest", for: indexPath) as? ButtonCellView
            cell?.button.setTitle("Schedule Notification", for: .normal)
            cell?.button.removeTarget(nil, action: nil, for: .allEvents)
            cell?.button.addTarget(self, action: #selector(scheduleNotification(_:)), for: .primaryActionTriggered)
            return cell!
        }
    }
}
