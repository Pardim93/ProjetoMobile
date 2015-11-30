//
//  AppDelegate.swift
//  DesignTest
//
//  Created by Wellington Pardim Ferreira on 8/10/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let parseManager = ParseManager.singleton

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Parse
        Parse.setApplicationId("cnmKI9SvIi10G7n7p74npxdBrHQQFT2Qcw8yMDhH", clientKey: "gasYEiYZAKeCoyyIBxC9IwDHspTxs1mwjTkrFFih")
        
        
//        parseManager.zerar()
        
//        self.beginEx()
//        self.beginProvas()
//        self.beginProva()
//        self.beginFinishRegistro()
        self.verifyLogin()
//        self.beginAvaliacao()
        
//        self.beginInserir()
        
        //Facebook
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
//        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        //Facebook
        FBSDKAppEvents.activateApp()

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
// MARK: - Core Data stack    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "BEPID.Teste" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("DesignTest", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

//    MARK: Custom
    func verifyLogin(){
        var logged = false
        
        logged = self.parseManager.autoLogin()
        
        if (logged){
            let newStoryboard = UIStoryboard(name: "Main", bundle: nil)
            self.window?.rootViewController = newStoryboard.instantiateViewControllerWithIdentifier("RevealViewController") as! SWRevealViewController
//            if(!completeUser()){
//                let registroView = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("RegistroViewController") as! RegistroViewController
//            }
        }
    }
    
    func beginAvaliarPerguntas(){
        let newStoryboard = UIStoryboard(name: "AvaliarPerguntas", bundle: nil)
        self.window?.rootViewController = newStoryboard.instantiateInitialViewController()

    }
    
    func beginFinishRegistro(){
        let newStoryboard = UIStoryboard(name: "IPhoneLogin", bundle: nil)
        self.window?.rootViewController = newStoryboard.instantiateViewControllerWithIdentifier("RegistroViewController")
    }

    func beginAvaliacao(){
        let newStoryboard = UIStoryboard(name: "AvaliacaoExercicios", bundle: nil)
        self.window?.rootViewController = newStoryboard.instantiateInitialViewController()
    }
    func beginProvas(){
        let newStoryboard = UIStoryboard(name: "iPhoneProvas", bundle: nil)
        self.window?.rootViewController = newStoryboard.instantiateInitialViewController()
    }
    func beginEx(){
        let newStoryboard = UIStoryboard(name: "IPhoneExercicios", bundle: nil)
        self.window?.rootViewController = newStoryboard.instantiateInitialViewController()
    }
    
    func beginInserir(){
        let newStoryboard = UIStoryboard(name: "IPhoneInserirExercicio", bundle: nil)
        self.window?.rootViewController = newStoryboard.instantiateInitialViewController()
    }
}

