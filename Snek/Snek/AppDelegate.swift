//
//  AppDelegate.swift
//  Snek
//
//  Created by Mayank Talwar on 28/02/21.
//


import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var startTime: String?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        self.startTime = "\(hour) : \(minutes) : \(seconds)"
        print("Start go brr")
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let endTime = "\(hour) : \(minutes) : \(seconds)"
        print(self.startTime!)
        print(endTime)
        print("Stop go brr")
    }
    
    
}
