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
        case .name: return NSLocalizedString("Name", comment: "Name section title")
        case .properties: return NSLocalizedString("Properties", comment: "Properties section title")
        case .inventory: return NSLocalizedString("Inventory", comment: "Inventory section title")
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
        else if item.item.type.equippable, !item.equipped {
            showOptions(equippable: item)
        }
    }
    
    // MARK: - Inventory item functions
    
    private func showOptions(food: Food) {
        
        guard GameData.shared.player != nil else {return}

        let alert = UIAlertController(title: NSLocalizedString("Eat", comment: "Eat alert sheet title"), message: NSLocalizedString("Would you like to eat?\nIt increases your health by 4 points and takes one portion of your food rations", comment: "Eat alert sheet message"), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Eat", comment: "Eat option title"), style: .default, handler: { (_) in
            GameData.shared.player.eat()
            self.characterTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel option title"), style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showOptions(potion: Potion) {
        
        guard GameData.shared.player != nil, let property = potion.modifiedProperty else {return}
        
        var message: String!
        
        switch property {
        case .dexterity:
            message = String(format: NSLocalizedString("Restores your dexerity to start level (%d)", comment: "Dexerity potion option alert message format"), GameData.shared.player.dexterityStarting)
        case .health:
            message = String(format: NSLocalizedString("Restores your health to start level (%d)", comment: "Health potion alert message format"), GameData.shared.player.healthStarting)
        case .luck:
            message = String(format: NSLocalizedString("Restores your luck to start level (%d) and increses starting levelby one", comment: "Luck potoion alert message format"), GameData.shared.player.luckStarting)
        }
        
        let alert = UIAlertController(title: String(format: NSLocalizedString("Drink potion of %@?", comment: "Drink potion alert title format"), property.rawValue), message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Drink", comment: "Drink option title"), style: .default, handler: { (_) in
            
            GameData.shared.player.drink(potion: potion)
            self.characterTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel option title"), style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showOptions(equippable: InventoryWrapper) {
        
        guard GameData.shared.player != nil, equippable.item.type.equippable, !equippable.equipped else {return}
        
        let alert = UIAlertController(title: NSLocalizedString("Equip item?", comment: "Equip item alert title"), message: equippable.item.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Equip", comment: "Equip option title"), style: .default, handler: { (_) in
            GameData.shared.player.equip(item: equippable)
            self.characterTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button title"), style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
