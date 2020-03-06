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
                    case 1: property = .dexerity
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
        
        // TODO: Implement selection logic
    }

}
