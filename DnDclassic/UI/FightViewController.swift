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
    
    var figthOver: ((_ wayPoint: WayPoint?) -> ())?
    var didEscape: ((_ wayPoint: WayPoint) ->())?
    
    var fights: [Fight]!
    var action: FightAction! {
        didSet {
            if action != nil {
                fights = [Fight]()
                let orderedOpponents = action.opponents.sorted { (opponent1, opponent2) -> Bool in
                    return opponent1.order <= opponent2.order
                }
                for opponent in orderedOpponents {
                    let fight = Fight(player: GameData.shared.player, opponent: opponent)
                    fights.append(fight)
                }
            }
        }
    }
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        distributeCharacterData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        guard !action.isOver, GameData.shared.player != nil, !GameData.shared.player.isDead else {
            let alert = UIAlertController.simpleMessageAlert(message: NSLocalizedString("The battle is over", comment: "Alert message when fight is over")) {
                self.dismiss(animated: true) {
                    self.figthOver?(GameData.shared.player.isDead ? nil : self.action.win)
                }
            }
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
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
            return action.escape != nil ? 1 : 0
        }
        else {
            return action.opponents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if action != nil, let _section = Section(rawValue: indexPath.section) {
            
            if _section == .actions {
                if let escape = action.escape, let cell = tableView.dequeueReusableCell(withIdentifier: SceneWaypointCell.reuseId, for: indexPath) as? SceneWaypointCell {
                    
                    cell.setup(waypoint: escape)
                    return cell
                }
            }
            else if _section == .opponents, fights != nil, indexPath.row < fights.count, let cell = tableView.dequeueReusableCell(withIdentifier: FightOpponentCell.reuseId, for: indexPath) as? FightOpponentCell {
                
                let fight = fights[indexPath.row]
                cell.setup(opponent: fight.opponent)
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
        
        guard action != nil, !action.isOver else {
            dismiss(animated: true) {
                self.figthOver?(GameData.shared.player.isDead ? nil : self.action.win)
            }
            return
        }
        
        guard let section = Section(rawValue: indexPath.section) else {return}
        
        if section == .actions {
            escape()
        }
        else if section == .opponents, fights != nil, indexPath.row < fights.count {
            
            var fight = fights[indexPath.row]
            
            guard fight.opponent.health > 0 else {return}
            
            if action.order == .single && action.opponents.count > 1 {
                
                guard let current = action.currentOpponent, current == fight.opponent else {
                    let alert = UIAlertController.simpleMessageAlert(message: NSLocalizedString("You have to fight your opponents in sequential order!", comment: "Error message when user wants to find an opponent outside of order"))
                    present(alert, animated: true, completion: nil)
                    return
                }
            }
            
            var luck: Bool?
            if useLuckSwitch.isOn {
                let _luck = fight.player.tryLuck()
                luck = _luck.success
            }
            
            fight.performRound(withLuck: luck)
            
            distributeCharacterData()
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            
            useLuckSwitch.isOn = false
            
            if fight.opponent.health <= 0 {
                let alert = UIAlertController.simpleMessageAlert(message: NSLocalizedString("You won again!", comment: "Alert message when opponent was beaten"), title: NSLocalizedString("Congratlations!", comment:"Alert title when opponent was beaten")) {
                    
                    if GameData.shared.player.isDead || self.action.isOver {
                        self.dismiss(animated: true) {
                            self.figthOver?(GameData.shared.player.isDead ? nil : self.action.win)
                        }
                    }
                }
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Data integrations
    
    private func distributeCharacterData() {

        let healthStatus = Double(GameData.shared.player.health) / Double(max(GameData.shared.player.healthStarting, 1)) * 100
        healthLabel.text = NSLocalizedString("Health", comment: "Heatlh title") + ": " + String(format: NSLocalizedString("%d of %d - %0.0f%%", comment: "Character property display format"), GameData.shared.player.health, GameData.shared.player.healthStarting, healthStatus)
        
        let dexterityStatus = Double(GameData.shared.player.dexterity) / Double(max(GameData.shared.player.dexterityStarting, 1)) * 100
        dexterityLabel.text = NSLocalizedString("Dexterity", comment: "Dexterity title") + ": " + String(format: NSLocalizedString("%d of %d - %0.0f%%", comment: "Character property display format"), GameData.shared.player.dexterity, GameData.shared.player.dexterityStarting, dexterityStatus)
        
        let luckStatus = Double(GameData.shared.player.luck) / Double(max(GameData.shared.player.luckStarting, 1)) * 100
        luckLabel.text = NSLocalizedString("Luck", comment: "Luck title") + ": " + String(format: NSLocalizedString("%d of %d - %0.0f%%", comment: "Character property display format"), GameData.shared.player.luck, GameData.shared.player.luckStarting, luckStatus)
        
        if GameData.shared.player.luck < 0 {
            useLuckSwitch.isOn = false
            useLuckSwitch.isEnabled = false
        }
        else {
            useLuckSwitch.isEnabled = true
        }
    }
    
    private func displayPotions() {
        
    }
    
    private func escape() {
        
        let alert = FightViewController.excapeDialog(withTryLuck: {
            let luck = GameData.shared.player.tryLuck()
            GameData.shared.player.escape(goodLuck: luck.success)
            self.dismiss(animated: true) {
                self.figthOver?(GameData.shared.player.isDead ? nil : self.action.win)
            }
        }) {
            GameData.shared.player.escape()
            self.dismiss(animated: true) {
                self.figthOver?(GameData.shared.player.isDead ? nil : self.action.win)
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
    static func excapeDialog(withTryLuck: (() -> ())?, escape: (() -> ())?) -> UIAlertController {
        
        let alert = UIAlertController(title: NSLocalizedString("Escape", comment: "Escape alert title"), message: NSLocalizedString("Are you sure you want to escape? It'll cost you 2 healt points!", comment: "Escape alert message"), preferredStyle: .alert)
        
        if GameData.shared.player != nil && GameData.shared.player.luck > 0 {
            alert.addAction(UIAlertAction(title: NSLocalizedString("Try your luck", comment: "Escape alert luck option title"), style: .default, handler: { (_) in
                withTryLuck?()
            }))
        }
        
        if GameData.shared.player != nil {
            alert.addAction(UIAlertAction(title: NSLocalizedString("Escape", comment: "Escape alert default title"), style: .default, handler: { (_) in
                escape?()
            }))
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button title"), style: .cancel, handler: nil))
        
        return alert
    }
}
