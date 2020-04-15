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
    
    var scene: Scene! {
        willSet {
            if scene != nil {
                scene.changed = nil
            }
        }
        didSet {
            if scene != nil {
                waypoints = scene.wayPoints
                actions = scene.actions
                scene.changed = {[weak self] in self?.sceneChanged()}
            }
        }
    }
    
    private var waypoints: [WayPoint]?
    private var actions: [Action]?
    
    private enum Section: Int, CaseIterable {
        
        case story = 0, waypoints, actions, inventory
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        checkSceneCompleted()
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
    
    func checkSceneCompleted() {
        
        if GameData.shared.isCompleted(scene: scene), GameData.shared.player != nil, !GameData.shared.player.isDead {
            
            if let _waypoints = scene.returnWaypoints {
                waypoints = _waypoints
                sceneTableView.reloadData()
            }
            else if scene.wayPoints == nil, GameData.shared.player.journey.count > 1 {
                // Add return to previous scene if no waypoints and scene is completed
                let lastScene = GameData.shared.player.journey[GameData.shared.player.journey.count - 2]
                let waypoint = WayPoint(direction: .back, destination: lastScene.sceneId, caption: NSLocalizedString("Go back", comment: "Go back waypoint title"))
                waypoints = [waypoint]
                actions = nil
                sceneTableView.reloadData()
            }
        }
    }
    
    private func sceneChanged() {
        
        distributeGame()
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
            return (waypoints?.count ?? 0) + 1
        case .actions:
            return actions?.count ?? 0
        case .inventory:
            return scene.inventory?.count ?? 0
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
                if let _waypoints = waypoints, indexPath.row < _waypoints.count, let cell = tableView.dequeueReusableCell(withIdentifier: SceneWaypointCell.reuseId, for: indexPath) as? SceneWaypointCell {
                    
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
                if let _actions = actions, indexPath.row < _actions.count, let cell = tableView.dequeueReusableCell(withIdentifier: SceneActionCell.reuseId, for: indexPath) as? SceneActionCell {
                    
                    let action = _actions[indexPath.row]
                    cell.setup(action: action)
                    return cell
                }
                
            case .inventory:
                if let _inventory = scene.inventory, indexPath.row < _inventory.count, let cell = tableView.dequeueReusableCell(withIdentifier: SceneInventoryCell.reuseId, for: indexPath) as? SceneInventoryCell {
                    
                    let item = _inventory[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard GameData.shared.game != nil, scene != nil, let section = Section(rawValue: indexPath.section) else {return}
        
        if section == .waypoints, let waypoints = waypoints  {
            
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
                        GameData.shared.completed(scene: self.scene)
                        self.scene = _scene
                        self.distributeGame()
                        self.sceneTableView.reloadData()
                    }
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button title"), style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
        else if section == .actions, let _actions = actions, indexPath.row < _actions.count {
            
            let action = _actions[indexPath.row]
            perform(action: action)
        }
        else if section == .inventory, let _inventory = scene.inventory, indexPath.row < _inventory.count {
         
            grab(inventory: indexPath.row)
        }
    }
    
    // MARK: - Actions
    
    private func perform(action: Action) {
        
        // FIXME: Remove in production!
//        if scene.id == 173 {
//            let item = InventoryObject(type: .weapon, name: "Örök Álmot Adó Nyílvessző", identifier: "arrow_of_everlasting_dream", consumeWhenUsed: true)
//            GameData.shared.player.add(inventoryItem: item)
//        }
        
        if let condition = action.condition {
            
            if !GameData.shared.player.isFulfilled(condition: condition) {
                let alert = UIAlertController.simpleMessageAlert(message: NSLocalizedString("Sorry, you don't fulfill the condition to choos this way!", comment: "Message when waypoint condition is not fulfilled"))
                present(alert, animated: true, completion: nil)
                return
            }
            else {
                GameData.shared.player.use(itemIn: condition)
            }
        }
        
        if action.type == .tryLuck, let _action = action as? TryLuckAction {
            tryLuck(_action)
        }
        else if action.type == .fight, let _action = action as? FightAction {
            fight(_action)
        }
        else if action.type == .rest, let _action = action as? RestAction {
            rest(_action)
        }
        else if action.type == .roll, let _action = action as? RollAction {
            roll(_action)
        }
        else if action.type == .escape, let _action = action as? EscapeAction {
            escape(_action)
        }
        else if action.type == .force, let _action = action as? ForceAction {
            force(_action)
        }
        else if action.type == .propertyRoll, let _action = action as? PropertyRollAction {
            propertyRoll(_action)
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
        
        present(alert, animated: true) {
            GameData.shared.completed(scene: self.scene)
        }
    }
    
    private func fight(_ fight: FightAction) {
        
        performSegue(withIdentifier: Segues.fight, sender: fight)
    }
    
    private func advance(to wayPoint: WayPoint) {
        
        // FIXME: This is a test confition fulfillment for scene 396, remove in production!
//        if scene.id == 396 {
//            let key1 = InventoryObject(type: .key, name: "key1")
//            let key2 = InventoryObject(type: .key, name: "key2")
//            GameData.shared.player.add(inventoryItem: key1)
//            GameData.shared.player.add(inventoryItem: key2)
//        }
        
        if let condition = wayPoint.condition, !GameData.shared.player.isFulfilled(condition: condition) {
            let alert = UIAlertController.simpleMessageAlert(message: NSLocalizedString("Sorry, you don't fulfill the condition to choos this way!", comment: "Message when waypoint condition is not fulfilled"))
            present(alert, animated: true, completion: nil)
            return
        }
        
        advance(to: wayPoint.destination)
    }
    
    private func advance(to sceneId: Int) {
        
        guard let _scene = GameData.shared.game.scene(id: sceneId) else {return}
        guard GameData.shared.player != nil, !GameData.shared.player.isDead else {return}
                
        GameData.shared.advance(player: GameData.shared.player, scene: _scene)
        GameData.shared.completed(scene: scene)
        
        scene = _scene
        distributeGame()
        checkSceneCompleted()
        sceneTableView.reloadData()        
    }
    
    private func roll(_ action: RollAction) {
                
        let roll = Dice(number: action.dice).roll()
        
        var actions = [UIAlertAction]()
        for choice in action.choices {
            if choice.roll == roll {
                if let choiceAction = choice.action {
                    let _action = UIAlertAction(title: choiceAction.caption, style: .default) { (_) in
                        self.perform(action: choiceAction)
                    }
                    actions.append(_action)
                }
                else if let choiceWaypoint = choice.waypoint {
                    let _action = UIAlertAction(title: choiceWaypoint.caption, style: .default) { (_) in
                        self.advance(to: choiceWaypoint)
                    }
                    actions.append(_action)
                }
            }
        }
        if actions.isEmpty {
            let _action = UIAlertAction(title: NSLocalizedString("Roll again", comment: "Roll again option title"), style: .default) { (_) in
                self.roll(action)
            }
            actions.append(_action)
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Roll", comment: "Roll action dialog title"), message: String(format: NSLocalizedString("You rolled %d", comment: "Roll value format"), roll), preferredStyle: .alert)
        for _action in actions {
            alert.addAction(_action)
        }
        
        GameData.shared.player.log(event: .roll(value: roll))
        
        present(alert, animated: true) {
            GameData.shared.completed(scene: self.scene)
        }
    }
    
    private func escape(_ action: EscapeAction) {
        
        guard GameData.shared.player != nil, !GameData.shared.player.isDead, let scene = GameData.shared.game.scene(id: action.destination) else {return}
        
        let advanceBlock: ((_ scene: Scene, _ withLuck: Bool?) -> ()) = { (scene, withLuck) in
            GameData.shared.player.escape(goodLuck: withLuck)
            GameData.shared.advance(player: GameData.shared.player, scene: scene)
            self.scene = scene
            self.distributeGame()
            self.sceneTableView.reloadData()
        }
        
        let alert = FightViewController.excapeDialog(withTryLuck: {
            let luck = GameData.shared.player.tryLuck()
            advanceBlock(scene, luck.success)
        }) {
            advanceBlock(scene, nil)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func force(_ action: ForceAction) {
        
        guard GameData.shared.player != nil, !GameData.shared.player.isDead else {return}
        
        GameData.shared.player.hitDamage(points: action.damage)
        
        if GameData.shared.player.isDead {
            playerDied()
        }
        else {
            advance(to: action.destination)
        }
    }
    
    private func grab(inventory index: Int) {
        
        guard GameData.shared.player != nil, !GameData.shared.player.isDead, scene != nil, let _inventory = scene.inventory, index < _inventory.count else {return}
        
        let item = _inventory[index]
        GameData.shared.player.add(inventoryItem: item)
        scene.grabbed(inventory: index)
        distributeGame()
        sceneTableView.reloadData()
    }
    
    private func propertyRoll(_ action: PropertyRollAction) {
                
        let roll = PropertyRoll(character: GameData.shared.player, action: action).roll()
        
        let alert = UIAlertController(title: NSLocalizedString("Roll", comment: "Roll action dialog title"), message: String(format: NSLocalizedString("You rolled %d", comment: "Roll value format"), roll.roll), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: roll.waypoint.caption, style: .default, handler: { (_) in
            self.advance(to: roll.waypoint)
        }))
        GameData.shared.player.log(event: .roll(value: roll.roll))
        
        present(alert, animated: true) {
            GameData.shared.completed(scene: self.scene)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.fight, let destination = segue.destination as? FightViewController, let fight = sender as? FightAction {
            destination.action = fight
            destination.figthOver = {[weak self] (wayPoint) in
                if let _wayPoint = wayPoint {
                    self?.advance(to: _wayPoint)
                }
                else if GameData.shared.player.isDead {
                    self?.playerDied()
                }
                else {
                    self?.checkSceneCompleted()
                }
            }
            destination.didEscape = {[weak self] (wayPoint) in
                if GameData.shared.player.isDead {
                    self?.playerDied()
                }
                else {
                    self?.checkSceneCompleted()
                    self?.advance(to: wayPoint)
                }
            }
            GameData.shared.completed(scene: scene)
        }
    }
    
    private func playerDied() {
        
        let alert = UIAlertController.simpleMessageAlert(message: NSLocalizedString("You just died :(", comment: "Alert message when user gone KIA"), title: NSLocalizedString("Sorry", comment: "Alert title when user gone KIA")) {
            // FIXME: Proceed to dead screen
        }
        present(alert, animated: true, completion: nil)
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
