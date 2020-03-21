//
//  FightViewController.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 21/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class FightViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var healthLabel: UILabel!
    @IBOutlet var dexterityLabel: UILabel!
    @IBOutlet var luckLabel: UILabel!
    
    @IBOutlet var useLuckLabel: UILabel!
    @IBOutlet var useLuckSwitch: UISwitch!
    
    @IBOutlet var drinkPotionButton: UIButton!
    
    @IBOutlet var fightTableView: UITableView!
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        distributeCharacterData()
    }
    
    var action: FightAction!
    
    // MARK: - UI Customization
    
    private func setupUI() {
        
        setupHeader()
        setupTableView()
    }
    
    private func setupHeader() {
        
        drinkPotionButton.setTitle(NSLocalizedString("Drink potion", comment: "Drink potion button title"), for: .normal)
        
        useLuckLabel.text = NSLocalizedString("use when hit", comment: "Use luck when hittng on opponent label title")
        useLuckSwitch.isOn = false
        
        healthLabel.text = nil
        dexterityLabel.text = nil
        luckLabel.text = nil
    }
    
    private func setupTableView() {
        
        fightTableView.tableFooterView = UIView()
    }

    // MARK: - Actions
    
    @IBAction func drinkPutionButtonTouched(_ sender: Any) {
        
        displayPotions()
    }
    
    // MARK: - TableView
    
    private enum Section: Int, CaseIterable {
        case actions = 0, opponents
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard action != nil else {return 0}
        
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard action != nil, let _section = Section(rawValue: section) else {return 0}
        
        if _section == .actions {
            return 1
        }
        else {
            return action.opponents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if action != nil, let _section = Section(rawValue: indexPath.section) {
            
            if _section == .actions {
                if let cell = tableView.dequeueReusableCell(withIdentifier: SceneWaypointCell.reuseId, for: indexPath) as? SceneWaypointCell {
                    
                    cell.setup(waypoint: action.escape)
                    return cell
                }
            }
            else if _section == .opponents, indexPath.row < action.opponents.count, let cell = tableView.dequeueReusableCell(withIdentifier: FightOpponentCell.reuseId, for: indexPath) as? FightOpponentCell {
                
                let opponent = action.opponents[indexPath.row]
                cell.setup(opponent: opponent)
                return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - Data integrations
    
    private func distributeCharacterData() {

        let healthStatus = Double(GameData.shared.player.healthCurrent) / Double(max(GameData.shared.player.healthStarting, 1)) * 100
        healthLabel.text = NSLocalizedString("Health", comment: "Heatlh title") + ": " + String(format: NSLocalizedString("%d of %d - %0.0f%%", comment: "Character property display format"), GameData.shared.player.healthCurrent, GameData.shared.player.healthCurrent, healthStatus)
        
        let dexterityStatus = Double(GameData.shared.player.dexterityCurrent) / Double(max(GameData.shared.player.dexterityStarting, 1)) * 100
        dexterityLabel.text = NSLocalizedString("Dexterity", comment: "Dexterity title") + ": " + String(format: NSLocalizedString("%d of %d - %0.0f%%", comment: "Character property display format"), GameData.shared.player.dexterityCurrent, GameData.shared.player.dexterityCurrent, dexterityStatus)
        
        let luckStatus = Double(GameData.shared.player.luckCurrent) / Double(max(GameData.shared.player.luckStarting, 1)) * 100
        luckLabel.text = NSLocalizedString("Luck", comment: "Luck title") + ": " + String(format: NSLocalizedString("%d of %d - %0.0f%%", comment: "Character property display format"), GameData.shared.player.luckCurrent, GameData.shared.player.luckCurrent, luckStatus)
        
        if GameData.shared.player.luckCurrent < 0 {
            useLuckSwitch.isOn = false
            useLuckSwitch.isEnabled = false
        }
        else {
            useLuckSwitch.isEnabled = true
        }
    }
    
    private func displayPotions() {
        
    }
}
