//
//  CharacterViewController.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 06/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var characterTableView: UITableView!
    
    private enum Section: Int, CaseIterable {
        case name = 0, properties, inventory
    }
    
    private enum PropertyRow: Int, CaseIterable {
        case health = 0, dexerity, luck
    }
    
    // MARK: - Controller Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
        
        if GameData.shared.player != nil {
            GameData.shared.player.changed = {[weak self] in
                self?.characterTableView.reloadData()
            }
        }
    }
    
    // MARK: - UI Customization

    private func setupUI() {
        
        characterTableView.tableFooterView = UIView()
    }
    
    // MARK: - Tableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard GameData.shared.player != nil else {return 0}
        
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard GameData.shared.player != nil, let _section = Section(rawValue: section) else {return 0}
        
        switch _section {
        case .name:
            return 1
        case .properties:
            return PropertyRow.allCases.count
        case .inventory:
            return GameData.shared.player.inventory.count
        }
    }
    
    private let cellReuseId = "characterViewCell"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if GameData.shared.player != nil, let section = Section(rawValue: indexPath.section) {
            
            switch section {
            case .name:
                if let cell = tableView.dequeueReusableCell(withIdentifier: CharacterViewNameCell.reuseId, for: indexPath) as? CharacterViewNameCell {
                    cell.setup(name: GameData.shared.player.name)
                    return cell
                }
            case .properties:
                if let cell = tableView.dequeueReusableCell(withIdentifier: CharacterViewPropertyCell.reuseId, for: indexPath) as? CharacterViewPropertyCell {
                    var property: CharacterProperty!
                    switch indexPath.row {
                    case 0: property = .health
                    case 1: property = .dexterity
                    default: property = .luck
                    }
                    cell.setup(character: GameData.shared.player, property: property)
                    return cell
                }
            case .inventory:
                if indexPath.row < GameData.shared.player.inventory.count, let cell = tableView.dequeueReusableCell(withIdentifier: CharacterViewInventoryCell.reuseId, for: indexPath) as? CharacterViewInventoryCell {
                    let item = GameData.shared.player.inventory[indexPath.row]
                    cell.setup(item: item)
                    return cell
                }
            }
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let _section = Section(rawValue: section) else {return nil}
        
        switch _section {
        case .name:         return Localization.name
        case .properties:   return Localization.properties
        case .inventory:    return Localization.inventory
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard GameData.shared.player != nil, let section = Section(rawValue: indexPath.section), section == .inventory, indexPath.row < GameData.shared.player.inventory.count else {return}
        
        let item = GameData.shared.player.inventory[indexPath.row]
        
        if item.item.type == .food, let food = item.item as? Food {
            showOptions(food: food)
        }
        else if item.item.type == .potion, let potion = item.item as? Potion {
            showOptions(potion: potion)
        }
        else {
            showOptions(inventoryItem: item)
        }
    }
    
    // MARK: - Inventory item functions
    
    private func showOptions(food: Food) {
        
        guard GameData.shared.player != nil, GameData.shared.game != nil, let currentScene = GameData.shared.game.scene(id: GameData.shared.currentSceneId) else {return}

        let alert = UIAlertController(title: Localization.titleEat, message: Localization.messageEat, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Localization.titleEat, style: .default, handler: { (_) in
            GameData.shared.player.eat(gainModifier: currentScene.restGainModifier)
            self.characterTableView.reloadData()
        }))
        alert.addAction(UIAlertAction.cancelAction())
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showOptions(potion: Potion) {
        
        guard GameData.shared.player != nil, let property = potion.modifiedProperty else {return}
        
        var message: String!
        
        switch property {
        case .dexterity:
            message = String(format: Localization.messageFormatDexterityPotion, GameData.shared.player.dexterityStarting)
        case .health:
            message = String(format: Localization.messageFormatHealthPotion, GameData.shared.player.healthStarting)
        case .luck:
            message = String(format: Localization.messageFormatLuckPotion, GameData.shared.player.luckStarting)
        }
        
        let alert = UIAlertController(title: String(format: Localization.messageFormatDrinkPotion, property.description), message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Localization.buttonTitleDrinkPotion, style: .default, handler: { (_) in
            
            GameData.shared.player.drink(potion: potion)
            self.characterTableView.reloadData()
        }))
        alert.addAction(UIAlertAction.cancelAction())
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showOptions(inventoryItem: InventoryWrapper) {
        
        guard GameData.shared.player != nil else {return}
        
        if inventoryItem.equipped, !(inventoryItem.item.canUnEquip ?? true) {
            
            let alert = UIAlertController.simpleMessageAlert(message: Localization.messageCannotUnequip)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: nil, message: String(format: Localization.messageFormatInventoryItem, inventoryItem.item.description), preferredStyle: .alert)
        
        if inventoryItem.item.type.equippable {
            
            if inventoryItem.equipped {
                alert.addAction(UIAlertAction(title: Localization.buttonTitleUnequip, style: .default, handler: { (_) in
                    GameData.shared.player.equip(item: inventoryItem, equipped: false)
                    self.characterTableView.reloadData()
                }))
            }
            else {
                alert.addAction(UIAlertAction(title: Localization.buttonTitleEquip, style: .default, handler: { (_) in
                    if GameData.shared.player.equip(item: inventoryItem, equipped: true) {
                        self.characterTableView.reloadData()
                    }
                    else {
                        let errorAlert = UIAlertController.simpleMessageAlert(message: Localization.messageCannotEquip)
                        alert.dismiss(animated: true) {
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                    }
                }))
            }
        }
        
        alert.addAction(UIAlertAction(title: Localization.titleDropItem, style: .destructive, handler: { (_) in
            
            GameData.shared.player.drop(inventoryItem: inventoryItem)
            if GameData.shared.game != nil, let scene = GameData.shared.game.scene(id: GameData.shared.currentSceneId) {
                scene.dropped(inventoryItem: inventoryItem.item)
            }
            self.characterTableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction.cancelAction())
        
        present(alert, animated: true, completion: nil)
    }
}
