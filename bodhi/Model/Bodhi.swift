//
//  Bodhi.swift
//  bodhi
//
//  Created by Joseph Hall on 10/26/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import Foundation

class Bodhi {
    private var _name: String
    private var _popUpGroup: String
    private var _city: String
    private var _state: String
    private var _temple: String
    private var _teacher: String
    private var _practice: String
    private var _senderId: String
    private var _key: String
    
    var name: String {
        return _name
    }
    
    var popUpGroup: String {
        return _popUpGroup
    }
    
    var city: String {
        return _city
    }
    
    var state: String {
        return _state
    }
    
    var temple: String {
        return _temple
    }
    
    var teacher: String {
        return _teacher
    }
    
    var practice: String {
        return _practice
    }
    
    var senderId: String {
        return _senderId
    }
    
    var key: String {
        return _key
    }
    
    
    init(name: String, popUpGroup: String, city: String, state: String, temple: String, teacher: String, practice: String, senderId: String, key: String) {
        self._name = name
        self._popUpGroup = popUpGroup
        self._city = city
        self._state = state
        self._temple = temple
        self._teacher = teacher
        self._practice = practice
        self._senderId = senderId
        self._key = key
    }
    
}

