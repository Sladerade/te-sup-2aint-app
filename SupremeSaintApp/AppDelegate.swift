import UIKit
import TwitterKit
import Firebase
import IQKeyboardManager
import FirebaseAuth
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        TWTRTwitter.sharedInstance().start(withConsumerKey:"lwMfhTGdIpZ8fOMtKJYntC1re", consumerSecret:"XDqcLSV0ZyUcqDKh0TAjdbNnImMy5HQhGr7hH3ZpgYOmcWsYbQ")
        
        IQKeyboardManager.shared().isEnabled = true
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        
        if Auth.auth().currentUser != nil
        {
            let board = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = board.instantiateViewController(withIdentifier: "tabBarcontroller")
            window?.rootViewController = tabBar
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Registration succeeded! Token: ", token)
        let a = Messaging.messaging().fcmToken
        print("FCM token: \(a ?? "")")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }

    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground, received: \n \(notification.request.content)")
        
        guard let dict = notification.request.content.userInfo["aps"] as? NSDictionary else { return }
        if let alert = dict["alert"] as? [String: String] {
            let body = alert["body"]!
            let title = alert["title"]!
            print("Title:\(title) + body:\(body)")
            self.showAlertAppDelegate(title: title, message: body, buttonTitle: "ok", window: self.window!)
        } else if let alert = dict["alert"] as? String {
            print("Text: \(alert)")
            self.showAlertAppDelegate(title: alert, message: "", buttonTitle: "ok", window: self.window!)
        }
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle tapped push from background, received: \n \(response.notification.request.content)")
        completionHandler()
    }
    
    func showAlertAppDelegate(title: String, message: String, buttonTitle: String, window: UIWindow) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        window.rootViewController?.present(alert, animated: false, completion: nil)
    }
    
    
    
}


