//
//  NotificationHelper.swift
//  Listener
//
//  Created by Chunbo Hu on 2018/3/12.
//  Copyright © 2018年 Chunbo Hu. All rights reserved.
//

import Foundation
private let shared = NotificationHelper()
class NotificationHelper {
    class var sharedInstance: NotificationHelper {
        return shared
    }
    
    let notification_selectPlayList: Notification.Name = Notification.Name("notification_selectPlayList")
}
