//
//  InfoInterfaceController.swift
//  scoutwatch
//
//  Created by Dirk Hermanns on 30.12.15.
//  Copyright © 2015 private. All rights reserved.
//

import Foundation
import WatchKit

class InfoInterfaceController: WKInterfaceController {
    
    @IBOutlet var versionLabel: WKInterfaceLabel!
    @IBOutlet var serverUriLabel: WKInterfaceLabel!
    @IBOutlet var cachedValuesLabel: WKInterfaceLabel!
    @IBOutlet var backgroundUpdatesLabel: WKInterfaceLabel!
    
    @IBAction func doCloseAction() {
        self.dismiss()
    }
    
    override func willActivate() {
        
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        displayLabels()
    }
    
    func displayLabels() {
        
        serverUriLabel.setText(UserDefaultsRepository.readBaseUri())
        
        // version number
        let versionNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        versionLabel.setText("V\(versionNumber).\(buildNumber)")
        
        // cached values
        let todaysBgData = NightscoutDataRepository.singleton.loadTodaysBgData()
        let yesterdaysBgData = NightscoutDataRepository.singleton.loadYesterdaysBgData()
        cachedValuesLabel.setText("\(todaysBgData.count) / \(yesterdaysBgData.count)")
        
        // background updates
        var text = "Complication updates (initiated from phone app): \(BackgroundRefreshLogger.phoneUpdates)"
        text += "\nNew data: \(BackgroundRefreshLogger.phoneUpdatesWithNewData), existing: \(BackgroundRefreshLogger.phoneUpdatesWithSameData), old: \(BackgroundRefreshLogger.phoneUpdatesWithOldData)\n"
        
        text += "\nBackground refreshes: \(BackgroundRefreshLogger.backgroundRefreshes) (\(BackgroundRefreshLogger.formattedBackgroundRefreshesPerHour) per hour)"
        text += "\nBackground URL sessions: \(BackgroundRefreshLogger.backgroundURLSessions) (\(BackgroundRefreshLogger.formattedBackgroundRefreshesStartingURLSessions))"
        
        text += "\nNew data: \(BackgroundRefreshLogger.backgroundURLSessionUpdatesWithNewData), existing: \(BackgroundRefreshLogger.backgroundURLSessionUpdatesWithSameData), old: \(BackgroundRefreshLogger.backgroundURLSessionUpdatesWithOldData)\n"
        
        text += "\nBackground tasks log:\n"
        text += BackgroundRefreshLogger.logs.joined(separator: "\n")
        backgroundUpdatesLabel.setText(text)
    }
}
