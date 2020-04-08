//
//  NotificationManager.swift
//  Plante Bluetooth
//
//  Created by Naomi Baudoin on 08.04.20.
//  Copyright © 2020 LVN. All rights reserved.
//

import Foundation
import UserNotifications
//
//struct Notification {
//    var id: String
//    var title: String
//    var body: String
//    
//}

class LocalNotificationManager {
//    var notifications = [Notification]()
//    
//    func requestPermission() -> Void {
//        UNUserNotificationCenter
//            .current()
//            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
//                if granted == true && error == nil {
//                    // We have permission!
//                }
//        }
//    }
//    func addNotification(title: String, body:String) -> Void {
//        notifications.append(Notification(id: UUID().uuidString, title: title, body: body))
//       }
//       
//    func scheduleNotifications(Date: Date) -> Void {
//       for notification in notifications {
//           let content = UNMutableNotificationContent()
//           content.title = notification.title
//           content.body = notification.body
//           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
////           let trigger = UNCalendarNotificationTrigger(dateMatching: "DateComponents(Date)", repeats: false)
//           let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
//           
//           UNUserNotificationCenter.current().add(request) { error in
//               guard error == nil else { return }
//               print("Scheduling notification with id: \(notification.id)")
//           }
//       }
//   }
}

