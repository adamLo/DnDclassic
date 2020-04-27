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
    private var potion: CharacterProperty? {
        get {
            guard let potion = inventory.first(where: { (item) -> Bool in
                return item.item.type == .potion
            })?.item as? Potion else {return nil}
            return potion.modifiedProperty
        }
        set {
            inventory.removeAll { (item) -> Bool in
                return item.item.type == .potion
            }
            if let _value = newValue {
                let potion = Potion(type: _value)
                inventory.append(InventoryWrapper(item: potion))
            }
        }
    }
    private var inventory = Character.startInventory
    
    private enum Section: Int {
        case name = 0, properties, potion, inventory
    }
    
    private enum PropertyRow: Int {
        case health = 0, dexerity, luck
    }
    
    var playerCreated: ((_ player: Character) -> ())?
    
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
        
        title = Localization.navigationTitleCharacterEdit
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
                        self?.name = newName
                    }
                    
                    return cell
                }
            case .properties:
                if let _row = PropertyRow(rawValue: indexPath.row), let cell = tableView.dequeueReusableCell(withIdentifier: CharacterEditPropertyCell.reuseId, for: indexPath) as? CharacterEditPropertyCell {
                    
                    var value: Int = 0
                    var type: CharacterProperty = .dexterity
                    switch _row {
                    case .dexerity:
                        value = dexerity ?? 0
                        type = .dexterity
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
                        self?.change(potion: self?.potion)
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
        case .name:         return Localization.name
        case .properties:   return Localization.properties
        case .potion:       return Localization.potion
        case .inventory:    return Localization.inventory
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    // MARK: - Data integration
    
    private func change(property: CharacterProperty, indexPath: IndexPath) {
        
        switch property {
        case .dexterity: dexerity = Character.generate(property: property)
        case .health: health = Character.generate(property: property)
        case .luck: luck = Character.generate(property: property)
        }
        
        characterTableView.beginUpdates()
        characterTableView.reloadRows(at: [indexPath], with: .automatic)
        characterTableView.endUpdates()
    }

    private func change(potion current: CharacterProperty?) {
        
        let reload: (() -> ()) = {
            self.characterTableView.beginUpdates()
            self.characterTableView.reloadSections(IndexSet(arrayLiteral: Section.inventory.rawValue, Section.potion.rawValue), with: .automatic)
            self.characterTableView.endUpdates()
        }
                
        let alert = UIAlertController(title: Localization.potion, message: Localization.messageSelectPotion, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "\(current == .health ? "* " : "")" + Localization.titlePotionHealth, style: .default, handler: { (_) in
            self.potion = .health
            reload()
        }))
        
        alert.addAction(UIAlertAction(title: "\(current == .dexterity ? "* " : "")" + Localization.titlePotionDexterity, style: .default, handler: { (_) in
            self.potion = .dexterity
            reload()
        }))
        
        alert.addAction(UIAlertAction(title: "\(current == .luck ? "* " : "")" + Localization.titlePotionLuck, style: .default, handler: { (_) in
            self.potion = .luck
            reload()
        }))
        
        alert.addAction(UIAlertAction(title: Localization.buttontTitleRemove, style: .destructive, handler: { (_) in
            self.potion = nil
            reload()
        }))
        
        alert.addAction(UIAlertAction.cancelAction())
        
        present(alert, animated: true, completion: nil)
    }
    
    private func validateData() -> Character? {
        
        var errors = [String]()
        
        if name?.nilIfEmpty == nil {
            errors.append(Localization.messageNameNotSet)
        }
        
        if dexerity ?? 0 <= 0 {
            errors.append(Localization.messageDexterityNotSet)
        }
        
        if health ?? 0 <= 0 {
            errors.append(Localization.messageHealthNotSet)
        }
        
        if luck ?? 0 <= 0 {
            errors.append(Localization.messageLuckNotset)
        }
        
        if !errors.isEmpty {
            
            let alert = UIAlertController(title: Localization.messageCharacterIncomplete, message: errors.joined(separator: "\n"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Localization.buttonTitleOk, style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return nil
        }
        
        guard let _name = name, let _dexerity = dexerity, let _health = health, let _luck = luck else {return nil}
        
        let player = Character(isPlayer: true, name: _name, dexterity: _dexerity, health: _health, luck: _luck, inventory: inventory)
        
        return player
    }
    
    // MARK: - Actions
    
    @objc
    private func doneButtonTopuched(_ sender: Any) {
        
        if let player = validateData() {
            dismiss(animated: true) {
                self.playerCreated?(player)
            }
        }
    }
}
