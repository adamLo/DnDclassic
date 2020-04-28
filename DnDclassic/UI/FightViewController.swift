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
                    fight.opponentDamageEvent = {[weak self] waypoint in self?.damageEventTriggered(onPlayer: false, waypoint: waypoint)}
                    fight.playerDamageEvent = {[weak self] waypoint in self?.damageEventTriggered(onPlayer: true, waypoint: waypoint)}
                    fight.eventOccured = {[weak self] waypoint in self?.fightEventTriggered(waypoint: waypoint)}
                    fights.append(fight)
                }
            }
        }
    }
    
    private var fightRounds = 0
    
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
            let alert = UIAlertController.simpleMessageAlert(message: Strings.messageFightOver) {
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
        
        drinkPotionButton.setTitle(Strings.buttonTitleDrinkPotion, for: .normal)
        
        useLuckLabel.text = Strings.titleUseLuck
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
            
            let fight = fights[indexPath.row]
            
            guard fight.opponent.health > 0 else {return}
            
            if action.order == .single && action.opponents.count > 1 {
                
                guard let current = action.currentOpponent, current == fight.opponent else {
                    let alert = UIAlertController.simpleMessageAlert(message: Strings.messageFightWrongOrder)
                    present(alert, animated: true, completion: nil)
                    return
                }
            }
            
            var luck: Bool?
            if fight.canTryLuck, useLuckSwitch.isOn {
                let _luck = fight.player.tryLuck()
                luck = _luck.success
            }
            
            fight.performRound(withLuck: luck)
            
            fightRounds += 1
            
            distributeCharacterData()
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            
            useLuckSwitch.isOn = false
            
            if fight.opponent.health <= 0 {
                let alert = UIAlertController.simpleMessageAlert(message: Strings.messagePlayerWonFight, title: Strings.titlePlayerWonFight) {
                    
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
        healthLabel.text = Strings.health + ": " + String(format: Strings.displayFormatProperty, GameData.shared.player.health, GameData.shared.player.healthStarting, healthStatus)
        
        let dexterityStatus = Double(GameData.shared.player.dexterity) / Double(max(GameData.shared.player.dexterityStarting, 1)) * 100
        dexterityLabel.text = Strings.dexterity + ": " + String(format: Strings.displayFormatProperty, GameData.shared.player.dexterity, GameData.shared.player.dexterityStarting, dexterityStatus)
        
        let luckStatus = Double(GameData.shared.player.luck) / Double(max(GameData.shared.player.luckStarting, 1)) * 100
        luckLabel.text = Strings.luck + ": " + String(format: Strings.displayFormatProperty, GameData.shared.player.luck, GameData.shared.player.luckStarting, luckStatus)
        
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
        
        if let _availableRound = action.escapeAvailableInRound, _availableRound > fightRounds {
            let alert = UIAlertController.simpleMessageAlert(message: Strings.messageEscapeUnavailable)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = FightViewController.escapeDialog(withTryLuck: {
            let luck = GameData.shared.player.tryLuck()
            GameData.shared.player.escape(goodLuck: luck.success, escapeDamage: self.action.escapeDamage)
            self.dismiss(animated: true) {
                self.figthOver?(GameData.shared.player.isDead ? nil : self.action.escape ?? self.action.win)
            }
        }) {
            GameData.shared.player.escape(escapeDamage: self.action.escapeDamage)
            self.dismiss(animated: true) {
                self.figthOver?(GameData.shared.player.isDead ? nil : self.action.escape ?? self.action.win)
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
    private func damageEventTriggered(onPlayer: Bool, waypoint: WayPoint) {
        
        let title = onPlayer ? Strings.titleDamageSuffered : Strings.titleDamageMade
        
        let alert = UIAlertController.simpleMessageAlert(message: String(format: Strings.alertMessageAdvance, waypoint.caption), title: title) {
            self.dismiss(animated: true) {
                self.figthOver?(waypoint)
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
    private func fightEventTriggered(waypoint: WayPoint) {
        
        let alert = UIAlertController.simpleMessageAlert(message: String(format: Strings.alertMessageAdvance, waypoint.caption)) {
            self.dismiss(animated: true) {
                self.figthOver?(waypoint)
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
    static func escapeDialog(withTryLuck: (() -> ())?, escape: (() -> ())?) -> UIAlertController {
        
        let alert = UIAlertController(title: Strings.titleEscape, message: Strings.messageEscape, preferredStyle: .alert)
        
        if GameData.shared.player != nil && GameData.shared.player.luck > 0 {
            alert.addAction(UIAlertAction(title: Strings.titleTryLuck, style: .default, handler: { (_) in
                withTryLuck?()
            }))
        }
        
        if GameData.shared.player != nil {
            alert.addAction(UIAlertAction(title: Strings.titleEscape, style: .default, handler: { (_) in
                escape?()
            }))
        }
        
        alert.addAction(UIAlertAction.cancelAction())
        
        return alert
    }
}
