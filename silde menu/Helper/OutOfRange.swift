//
//  OutOfRange.swift
//  SistaCafe
//
//  Created by Sakkaphong Luaengvilai on 9/20/2560 BE.
//  Copyright © 2560 Donuts. All rights reserved.
//

import Foundation

extension Array {

    func get(_ index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}
