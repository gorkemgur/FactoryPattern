//
//  ViewController.swift
//  factorySample
//
//  Created by Görkem Gür on 23.10.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        example()
    }
    
    func example() {
        // UserDefaults için repository
        let userDefaultsRepo = UserDataRepository(storageType: .userDefaults)
        
        // Keychain için repository
        let keychainRepo = UserDataRepository(storageType: .keychain)
        
        // CoreData için repository
        let coreDataRepo = UserDataRepository(storageType: .coreData(modelName: "YourModelName"))
        // Örnek kullanım
        let user = User(id: "1", name: "John Doe", email: "john@example.com", isActive: true)
        
        do {
            // Hassas bilgileri Keychain'e kaydet
            try keychainRepo.saveUser(user)
            
            // Genel bilgileri UserDefaults'a kaydet
            try userDefaultsRepo.saveUser(user)
            
            // Kalıcı veriyi CoreData'ya kaydet
            try coreDataRepo.saveUser(user)
            
            // Veriyi oku
            if let savedUser = try keychainRepo.getUser(id: user.id) {
                print("Kullanıcı bulundu: \(savedUser.name)")
            }
        } catch {
            print("Hata: \(error)")
        }
    }


}

