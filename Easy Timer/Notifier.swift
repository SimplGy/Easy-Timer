//
//  Sets a notification to ring an alarm/play a sound
//  Only one may be active at any time for this app, so setting a new one implies clearing any old ones
//

import UIKit


class Notifier {
    
    static let settings = UIUserNotificationSettings(forTypes: .Sound | .Alert, categories: nil)
    static let app = UIApplication.sharedApplication()
    
    /**
    Configure notifications, ask user for permission
    */
    static func prepare(){
//        println("configured settings: \(app.currentUserNotificationSettings())")
        app.registerUserNotificationSettings(settings)
    }
    
    
    /**
    Set a new notification time
    Clears existing ones first
    
    :param: time what time to set the notification for
    */
    static func set(time: NSDate) {
        clear()
        var notification = UILocalNotification()
        notification.fireDate = time
        notification.alertTitle = "Time's Up!"
        var span = Int(ceil(time.timeIntervalSinceNow))
        notification.alertBody = "Your \(span) second timer is ringing."
        notification.soundName = AudioController.getRandomSoundName()
        notification.alertAction = "Cool Beans"
        println("Scheduling notification for: \(time)")
        app.scheduleLocalNotification(notification) // these only fire when the app is closed or in the background
    }
    
    
    /**
    Get rid of any and all existing notifications
    */
    static func clear() {
    
    }
    
}
