//
//  AezakmiTestApp.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 29.07.2024.
//

import SwiftUI

@main
struct AezakmiTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
               LoginMethodsView()
            }
        }
    }
}
