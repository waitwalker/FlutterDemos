//
//  FlutterOrientationPlugin.swift
//  Runner
//
//  Created by etiantian on 2020/4/14.
//

import UIKit
import Flutter

class FlutterOrientationPlugin: NSObject,FlutterPlugin {
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel:FlutterMethodChannel = FlutterMethodChannel(name: "com.etiantian/orientation", binaryMessenger: registrar.messenger())
        let instance:FlutterOrientationPlugin = FlutterOrientationPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if call.method == "setLandscapeRight" {
            appDelegate.isLandscape = true
            result(true)
        } else if call.method == "setPortrait" {
            appDelegate.isLandscape = false
            result(true)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
