//
//  NetworkServices.swift
//  MemoryQuest
//
//  Created by Nathan Lassiter on 5/5/24.
//

import Foundation

class NetworkServices {
    static let shared = NetworkServices()
    private init(){
        
    }
    private var user: User?
    
    func login(userName: String, completion: @escaping (Bool) -> Void) {
            DispatchQueue.global().async {
                sleep(2) // Simulate network delay
                DispatchQueue.main.async {
                    if userName == "Player1" {
                        self.user = User(firstName: "Nathan", lastName: "Lassiter", userName: "Player1", age: 28)
                        completion(true)
                    } else {
                        self.user = nil
                        completion(false)
                    }
                }
            }
        }
    }
