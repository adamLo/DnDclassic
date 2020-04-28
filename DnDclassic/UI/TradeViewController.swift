//
//  TradeViewController.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 24/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class TradeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tradeTableView: UITableView!
    
    private enum Section: Int {
        case trade = 0, inventory
    }
    
    var action: TradeAction! {
        didSet {
            if self.isViewLoaded {
                self.tradeTableView.reloadData()
            }
        }
    }
    
    // MARK: - Controller Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - UI customization
    
    private func setupUI() {
        
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        
        tradeTableView.tableFooterView = UIView()
    }
    
    private func setupNavigationBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
        title = Strings.navigationTitleTrade
    }
    
    // MARK: - UItableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
                
        guard action != nil else {return 0}
        
        var sections = 1
        if GameData.shared.player != nil {
            sections += 1
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let _section = Section(rawValue: section) else {return 0}
        
        if _section == .trade {
            return action.items.count
        }
        else if _section == .inventory {
            return GameData.shared.player == nil ? 0 : GameData.shared.player.inventory.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let _section = Section(rawValue: indexPath.section) else {return UITableViewCell()}
        
        if _section == .trade, let cell = tableView.dequeueReusableCell(withIdentifier: TradeItemCell.reuseId, for: indexPath) as? TradeItemCell {
            
            let item = action.items[indexPath.row]
            cell.setup(with: item)
            return cell
        }
        else if _section == .inventory, let cell = tableView.dequeueReusableCell(withIdentifier: CharacterViewInventoryCell.reuseId, for: indexPath) as? CharacterViewInventoryCell {
            
            let item = GameData.shared.player.inventory[indexPath.row]
            cell.setup(item: item)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let _section = Section(rawValue: indexPath.section), _section == .trade else {return}
        
        let item = action.items[indexPath.row]
        buy(item: item)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let _section = Section(rawValue: section) else {return nil}
        
        switch _section {
        case .trade:
            return Strings.sectionTitleStock
        case .inventory:
            return Strings.sectionTitleInventory
        }
    }
    
    // MARK: - Data integration
    
    private func buy(item: TradeItem) {
        
        guard item.price <= GameData.shared.player.money else {
            let alert = UIAlertController.simpleMessageAlert(message: Strings.messageNotEnoghMoney)
            present(alert, animated: true, completion: nil)
            return
        }
        
        if let itemId = item.inventoryItem.identifier?.nilIfEmpty, GameData.shared.player.hasItem(identifier: itemId) {
            let alert = UIAlertController.simpleMessageAlert(message: Strings.messageAlreadyPurchased)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: Strings.titlePurchase, message: String(format: Strings.messageFormatPurchase, item.inventoryItem.description), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.buttontitleBuy, style: .default, handler: { (_) in
            self.purchase(item: item)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction.cancelAction())
        
        present(alert, animated: true, completion: nil)
    }
    
    private func purchase(item: TradeItem) {
        
        GameData.shared.player.add(inventoryItem: item.inventoryItem)
        GameData.shared.player.pay(amount: item.price)
        
        tradeTableView.reloadData()
    }
    
    @objc
    private func close() {
        
        dismiss(animated: true, completion: nil)
    }
}
