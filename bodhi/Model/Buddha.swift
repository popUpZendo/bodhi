//
//  Buddha.swift
//  Pop Up Circle Test
//
//  Created by Joseph Hall on 10/5/17.
//  Copyright © 2017 Om Design. All rights reserved.
//

import Foundation

import Foundation

class Buddha {
    private var _name: String
    private var _city: String
    private var _key: String
    private var _temple: String
    private var _popUpGroup: String
    private var _teacher: String
    private var _practice: String
    
    var name: String {
        return _name
    }
    
    var city: String {
        return _city
    }
    
    var key: String {
        return _key
    }
    
    var temple: String {
        return _temple
    }
    
    var popUpGroup: String {
        return _popUpGroup
    }
    
    var teacher: String {
        return _teacher
    }
    
    var practice: String {
        return _practice
    }
    
    init(name: String, city: String, key: String, temple: String, popUpGroup: String, teacher: String,practice: String) {
        self._name = name
        self._city = city
        self._key = key
        self._temple = temple
        self._popUpGroup = popUpGroup
        self._teacher = teacher
        self._practice = practice
    }
    
}
