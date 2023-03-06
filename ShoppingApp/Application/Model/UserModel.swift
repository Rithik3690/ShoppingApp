//
//  UserModel.swift
//  

import Foundation

private protocol UserModelProtocol {
    static var kUD_username: String { get set }
    static var kUD_firstname: String { get set }
    static var kUD_lastName: String { get set }
    static var kUD_dob: String { get set }
    static var kUD_address: String { get set }
    static var kUD_pointsEarned: String { get set }
    static var kUD_walletBalance: String { get set }
    
    static func setValues(_ data: [String: Any])
    static func clearData()
}

struct UserModel: UserModelProtocol {
    
    fileprivate static var kUD_username: String = "com.test.ShoppingApp.username"
    fileprivate static var kUD_firstname: String = "com.test.ShoppingApp.firstname"
    fileprivate static var kUD_lastName: String = "com.test.ShoppingApp.lastName"
    fileprivate static var kUD_dob: String = "com.test.ShoppingApp.dob"
    fileprivate static var kUD_address: String = "com.test.ShoppingApp.address"
    fileprivate static var kUD_pointsEarned: String = "com.test.ShoppingApp.pointsEarned"
    fileprivate static var kUD_walletBalance: String = "com.test.ShoppingApp.walletBalance"
    
    static var username: String? {
        get {
            return UserDefaults.standard.string(forKey: kUD_username)
        } set {
            UserDefaults.standard.set(newValue, forKey: kUD_username)
        }
    }
    
    static var firstname: String? {
        get {
            return UserDefaults.standard.string(forKey: kUD_firstname)
        } set {
            UserDefaults.standard.set(newValue, forKey: kUD_firstname)
        }
    }
    
    static var lastName: String? {
        get {
            return UserDefaults.standard.string(forKey: kUD_lastName)
        } set {
            UserDefaults.standard.set(newValue, forKey: kUD_lastName)
        }
    }
    
    static var dob: String? {
        get {
            return UserDefaults.standard.string(forKey: kUD_dob)
        } set {
            UserDefaults.standard.set(newValue, forKey: kUD_dob)
        }
    }
    
    static var address: String? {
        get {
            return UserDefaults.standard.string(forKey: kUD_address)
        } set {
            UserDefaults.standard.set(newValue, forKey: kUD_address)
        }
    }
    
    static var pointsEarned: String? {
        get {
            return UserDefaults.standard.string(forKey: kUD_pointsEarned)
        } set {
            UserDefaults.standard.set(newValue, forKey: kUD_pointsEarned)
        }
    }
    
    static var walletBalance: String? {
        get {
            return UserDefaults.standard.string(forKey: kUD_walletBalance)
        } set {
            UserDefaults.standard.set(newValue, forKey: kUD_walletBalance)
        }
    }
    
    static func setValues(_ data: [String: Any]) {
        UserModel.username = data[App.StringConstants.username] as? String
        UserModel.firstname = data[App.StringConstants.firstname] as? String
        UserModel.lastName = data[App.StringConstants.lastName] as? String
        UserModel.dob = data[App.StringConstants.dob] as? String
        UserModel.address = data[App.StringConstants.address] as? String
        UserModel.pointsEarned = data[App.StringConstants.pointsEarned] as? String
        UserModel.walletBalance = data[App.StringConstants.walletBalance] as? String
    }
    
    static func clearData() {
        username = nil
        firstname = nil
        lastName = nil
        dob = nil
        address = nil
        pointsEarned = nil
        walletBalance = nil
    }
}
