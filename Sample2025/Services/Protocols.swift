//
//  Protocols.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

protocol LocationServiceDelegate: AnyObject {
    
    func didUpdateLocation(latitude: Double, longitude: Double)
    func didFailWithDefaultLocation()
}
