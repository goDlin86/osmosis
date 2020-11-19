//
//  AppDelegate.swift
//  Osmosis
//
//  Created by Денис on 12.11.2020.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let deck = Deck(cards: nil, shuffled: true)
        let stockPile = StockPile()
        let foundation = Foundation()
        let tableau = Tableau()
        
        let contentView = ContentView()
            .environmentObject(deck)
            .environmentObject(stockPile)
            .environmentObject(foundation)
            .environmentObject(tableau)

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

