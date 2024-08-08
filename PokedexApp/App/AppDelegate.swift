//
//  AppDelegate.swift
//  PokedexApp
//
//  Created by 김동현 on 8/8/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // 기본 윈도우 설정
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = UINavigationController(rootViewController: MainViewController())
    window.makeKeyAndVisible()
    
    self.window = window
    
    return true
  }

}

