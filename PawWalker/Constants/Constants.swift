//
//  Constants.swift
//  PawWalker
//
//  Created by shagar on 07/12/24.
//

struct Strings {
    static let contentTypeString = "application/json; charset=utf-8"
    static let bearer = "Bearer "
    static let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTczMzc1NDA4OSwianRpIjoiNmE3NDNmNTYtM2M2MS00ZGJjLWIxNTYtZDY4NTJkMmE4ZjMxIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6IjE3YTA5ZDQxLTE1NjktNDQ2MS04Mjc2LTc0ZDg5ODkyNzgzMyIsIm5iZiI6MTczMzc1NDA4OSwiZXhwIjoxNzMzODQwNDg5fQ.NpAQ2TqR4wOuD1j9JcsXDOsaLx6BUb4ae9PYGdpmVh4"
    static let applicationJson = "application/json"
}

enum FloatingSize: Float {
    case zoom = 10.0
    case locationZoom = 15.0
    case divider20 = 20.0
    case defaultValue = 1.0
    case divider100 = 100.0
    case divider2 = 2.0
}

enum TabBarItems : String {
    case home
    case clinic
    case favourites
    case account
    case store
}

struct ObserverName {
    static let alpha = "alpha"
}

struct FileNames {
    static let remoteConfigPlist = "RemoteConfigDefaults"
}

enum Appscheme : String {
    case dev = "DEVELOPMENT"
    case production = "PRODUCTION"
}
