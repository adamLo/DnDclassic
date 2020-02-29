//
//  CharacterEditViewController.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 26/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class CharacterEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var characterTableView: UITableView!
    
    private var name: String?
    private var dexerity: Int?
    private var health: Int?
    private var luck: Int?
    private var potion: CharacterProperty?
    private let inventory = Character.startInventory
    
    private enum Section: Int {
        case name = 0, properties, potion, inventory
    }
    private enum PropertyRow: Int {
        case health = 0, dexerity, luck
    }
    
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - UI customization
    
    private func setupUI() {
                    
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        
        title = NSLocalizedString("Your character", comment: "Character edit screeen navigation title")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTopuched(_:)))
    }
    
    private func setupTableView() {
        
        characterTableView.tableFooterView = UIView()
    }

    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let _section = Section(rawValue: section) else {return 0}
        
        switch _section {
        case .name: return 1
        case .properties: return 3
        case .potion: return 1
        case .inventory: return inventory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let _section = Section(rawValue: indexPath.section) {
            
            switch _section {
            case .name:
                if let cell = tableView.dequeueReusableCell(withIdentifier: CharacterEditNameCell.reuseId, for: indexPath) as? CharacterEditNameCell {
                    
                    cell.setup(name: name)
                    
                    cell.nameChanged = {[weak self] newName in
                        self?.change(name: newName, indexPath: indexPath)
                    }
                    
                    return cell
                }
            case .properties:
                if let _row = PropertyRow(rawValue: indexPath.row), let cell = tableView.dequeueReusableCell(withIdentifier: CharacterEditPropertyCell.reuseId, for: indexPath) as? CharacterEditPropertyCell {
                    
                    var value: Int = 0
                    var type: CharacterProperty = .dexerity
                    switch _row {
                    case .dexerity:
                        value = dexerity ?? 0
                        type = .dexerity
                    case .health:
                        value = health ?? 0
                        type = .health
                    case .luck:
                        value = luck ?? 0
                        type = .luck
                    }
                    
                    cell.setup(type: type, value: value)
                    
                    cell.rollTouched = {[weak self] () in
                        self?.change(property: type, indexPath: indexPath)
                    }
                    return cell
                }
            case .potion:
                if let cell = tableView.dequeueReusableCell(withIdentifier: CharacterEditPotionCell.reuseId, for: indexPath) as? CharacterEditPotionCell {
                    
                    cell.setup(type: potion)
                    
                    cell.changeTouched = {[weak self] () in
                        self?.change(potion: self?.potion, indexPath: indexPath)
                    }
                    
                    return cell
                }
            case .inventory:
                if let cell = tableView.dequeueReusableCell(withIdentifier: CharacterEditInventoryItemCell.reuseId, for: indexPath) as? CharacterEditInventoryItemCell {
                    
                    let item = inventory[indexPath.row]
                    cell.setup(item: item)
                    return cell
                }
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let _section = Section(rawValue: section) else {return nil}
        
        switch _section {
        case .name:
            return NSLocalizedString("Name", comment: "Name section title")
        case .properties:
            return NSLocalizedString("Properties", comment: "Properties section title")
        case .potion:
            return NSLocalizedString("Potion", comment: "Potion section title")
        case .inventory:
            return NSLocalizedString("Inventory", comment: "Inventory section title")
        }
    }
    
    // MARK: - Data integration
    
    private func change(property: CharacterProperty, indexPath: IndexPath) {
        
        switch property {
        case .dexerity: dexerity = Character.generate(property: property)
        case .health: health = Character.generate(property: property)
        case .luck: luck = Character.generate(property: property)
        }
        
        reload(row: indexPath)
    }

    private func change(potion current: CharacterProperty?, indexPath: IndexPath) {
        
        let alert = UIAlertController(title: NSLocalizedString("Potion", comment: "Potion selection dialog title"), message: NSLocalizedString("Select potion to help you in your journey", comment: "Potion selection dialog message"), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "\(current == .health ? "* " : "")" + NSLocalizedString("Potion of Health", comment: "Potion of Health title"), style: .default, handler: { (_) in
            self.potion = .health
            self.reload(row: indexPath)
        }))
        
        alert.addAction(UIAlertAction(title: "\(current == .dexerity ? "* " : "")" + NSLocalizedString("Potion of Dexerity", comment: "Potion of Dexerity title"), style: .default, handler: { (_) in
            self.potion = .dexerity
            self.reload(row: indexPath)
        }))
        
        alert.addAction(UIAlertAction(title: "\(current == .luck ? "* " : "")" + NSLocalizedString("Potion of Luck", comment: "Potion of Luck title"), style: .default, handler: { (_) in
            self.potion = .luck
            self.reload(row: indexPath)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button title"), style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func change(name newValue: String?, indexPath: IndexPath) {
        
        name = newValue
        reload(row: indexPath)
    }
    
    private func reload(row: IndexPath) {
        
        characterTableView.beginUpdates()
        characterTableView.reloadRows(at: [row], with: .automatic)
        characterTableView.endUpdates()
    }
    
    // MARK: - Actions
    
    @objc
    private func doneButtonTopuched(_ sender: Any) {
        
    }
}
