//
//  SceneViewController.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 25/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class SceneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var sceneTableView: UITableView!
    @IBOutlet weak var sceneTitleLabel: UILabel!
    
    var scene: Scene!
    
    private enum Section: Int, CaseIterable {
        
        case story = 0, waypoints, actions
    }
    
    private struct Segues {
        static let fight = "fight"
    }
    
    var isFightOver = false
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if scene == nil, GameData.shared.game != nil, let _scene = GameData.shared.game.scene(id: GameData.shared.currentSceneId) {
            scene = _scene
        }

        setupUI()
        distributeGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        sceneTableView.reloadData()
    }
    
    // MARK: - UI customization
    
    private func setupUI() {
        
        setupTableView()
    }
    
    private func setupTableView() {
        
        sceneTableView.backgroundColor = UIColor.clear
        sceneTableView.tableFooterView = UIView()
    }
    
    // MARK: - Data integration
    
    private func distributeGame() {
        
        guard scene != nil else {return}
        
        let _title = String(format: NSLocalizedString("Scene %d", comment: "Scene navigation title format"), scene.id)
        title = title
        sceneTitleLabel.text = _title
        coverImageView.image = scene.image
        
        sceneTableView.contentInset = UIEdgeInsets(top: scene.image != nil ? coverImageView.bounds.size.height - 50 : 0, left: 0, bottom: 0, right: 0)
    }

    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard scene != nil, let _section = Section(rawValue: section) else {return 0}
        
        switch _section {
        case .story:
            return 1
        case .waypoints:
            return (scene.wayPoints?.count ?? 0) + 1
        case .actions:
            return scene.actions?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if scene != nil, let _section = Section(rawValue: indexPath.section) {
            
            switch _section {
                
            case .story:
                if let cell = tableView.dequeueReusableCell(withIdentifier: SceneStoryCell.reuseId, for: indexPath) as? SceneStoryCell {
                    
                    cell.setup(story: scene.story)
                    return cell
                }
                
            case .waypoints:
                if let _waypoints = scene.wayPoints, indexPath.row < _waypoints.count, let cell = tableView.dequeueReusableCell(withIdentifier: SceneWaypointCell.reuseId, for: indexPath) as? SceneWaypointCell {
                    
                    let waypoint = _waypoints[indexPath.row]
                    cell.setup(waypoint: waypoint)
                    return cell
                }
                else {
                    // FIXME: Cheating! Rmeove in production
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "cheat")
                    cell.textLabel?.text = "Go Directly to a location"
                    return cell
                }
                
            case .actions:
                if let _actions = scene.actions, indexPath.row < _actions.count, let cell = tableView.dequeueReusableCell(withIdentifier: SceneActionCell.reuseId, for: indexPath) as? SceneActionCell {
                    
                    let action = _actions[indexPath.row]
                    cell.setup(action: action)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard GameData.shared.game != nil, scene != nil, let section = Section(rawValue: indexPath.section) else {return}
        
        if section == .waypoints, let waypoints = scene.wayPoints  {
            
            if indexPath.row < waypoints.count {
                let wayPoint = waypoints[indexPath.row]
                advance(to: wayPoint)
            }
            else {
                let alert = UIAlertController(title: "Scene selection", message: nil, preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "Enter scene id"
                }
                alert.addAction(UIAlertAction(title: "Go to scene", style: .default, handler: { (_) in
                    if GameData.shared.game != nil, let textField = alert.textFields?.first, let sceneString = textField.text?.nilIfEmpty, let sceneId = Int(sceneString), let _scene = GameData.shared.game.scene(id: sceneId) {
                        GameData.shared.advance(player: GameData.shared.player, scene: _scene)
                        self.scene = _scene
                        self.distributeGame()
                        self.sceneTableView.reloadData()
                    }
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button title"), style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
        else if section == .actions, let actions = scene.actions, indexPath.row < actions.count {
            
            let action = actions[indexPath.row]
            perform(action: action)
        }
    }
    
    // MARK: - Actions
    
    private func perform(action: Action) {

        if action.type == .tryLuck, let _action = action as? TryLuckAction {
            tryLuck(_action)
        }
        else if action.type == .fight, let _action = action as? FightAction {
            fight(_action)
        }
        else if action.type == .rest, let _action = action as? RestAction {
            rest(_action)
        }
    }
    
    private func tryLuck(_ action: TryLuckAction) {
                
        let luck = GameData.shared.player.tryLuck()
        
        let alert = UIAlertController(title: NSLocalizedString("You tried your luck", comment: "Try luck action result title"), message: String(format: NSLocalizedString("You rolled %d, %@", comment: "Try luck action result message format"), luck.rolled, luck.success ? NSLocalizedString("Good luck!", comment: "Good luck result title") : NSLocalizedString("Bad luck :(", comment: "Bad luck result title")), preferredStyle: .alert)
        
        if luck.success {
            alert.addAction(UIAlertAction(title: action.goodLuck.caption, style: .default, handler: { (_) in
                self.advance(to: action.goodLuck)
            }))
        }
        else {
            alert.addAction(UIAlertAction(title: action.badLuck.caption, style: .default, handler: { (_) in
                self.advance(to: action.badLuck)
            }))
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func fight(_ fight: FightAction) {
        
        performSegue(withIdentifier: Segues.fight, sender: fight)
    }
    
    private func advance(to wayPoint: WayPoint) {
        
        guard let _scene = GameData.shared.game.scene(id: wayPoint.destination) else {return}
        
        GameData.shared.advance(player: GameData.shared.player, scene: scene)
        scene = _scene
        distributeGame()
        sceneTableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.fight, let destination = segue.destination as? FightViewController, let fight = sender as? FightAction {
            destination.action = fight
            destination.figthOver = {[weak self] (wayPoint) in
                if let _wayPoint = wayPoint {
                    self?.advance(to: _wayPoint)
                }
                else {
                    self?.playerDied()
                }
            }
            destination.didEscape = {[weak self] (wayPoint) in
                self?.advance(to: wayPoint)
            }
        }
    }
    
    private func playerDied() {
        
        let alert = UIAlertController.simpleMessageAlert(message: NSLocalizedString("You just died :(", comment: "Alert message when user gone KIA"), title: NSLocalizedString("Sorry", comment: "Alert title when user gone KIA")) {
            // FIXME: Proceed to dead screen
        }
    }
    
    private func rest(_ action: RestAction) {
        
        guard GameData.shared.player != nil else {return}
        
        GameData.shared.player.rest(health: action.health, dexterity: action.dexterity)
        
        let alert = UIAlertController(title: NSLocalizedString("Resting", comment: "Resting alert title"), message: NSLocalizedString("You feel refreshed after resting. Where would you like to go from here?", comment: "Resting alert message"), preferredStyle: .alert)
        for waypoint in action.finished {
            alert.addAction(UIAlertAction(title: waypoint.caption, style: .default, handler: { (_) in
                self.advance(to: waypoint)
            }))
        }
        
        present(alert, animated: true, completion: nil)
    }
}
