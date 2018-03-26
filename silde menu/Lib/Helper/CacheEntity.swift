//
//  CacheUserDefaultsEntity.swift
//  Wala-R2
//
//  Created by Sakkaphong on 1/8/18.
//  Copyright © 2018 Sakkaphong. All rights reserved.
//

import UIKit

class CacheEntity: NSObject {

    private let Cache : UserDefaults = UserDefaults.standard
    
    internal func RemoveAllCache() {
        guard let Domain = Bundle.main.bundleIdentifier else { return }
        self.Cache.removePersistentDomain(forName: Domain)
        self.Cache.synchronize()
    }

    internal var CurrentPage:[Int] {
        get {
            return self.Cache.array(forKey: "CurrentPage") as? [Int] ?? [0,0]
        }
        set {
            self.Cache.Save(Value: newValue, Key: "CurrentPage")
        }
    }
}

extension UserDefaults {
    func Save(Value : Any , Key : String) {
        UserDefaults.standard.set(Value, forKey: Key)
        UserDefaults.standard.synchronize()
    }
}
