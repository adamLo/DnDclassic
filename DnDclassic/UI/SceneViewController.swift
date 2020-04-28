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
        
        case story = 0, waypoints, actions, inventory, restart
    }
    
    private struct Segues {
        static let fight = "fight"
        static let trade = "trade"
    }
    
    var isFightOver = false
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if scene == nil, GameData.shared.game != nil, let _scene = GameData.shared.game.scene(id: GameData.shared.currentSceneId) {
            scene = _scene
        }

        setupUI()
        
        distributeScene()
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
        
        view.backgroundColor = Colors.defaultBackground
        
        setupTableView()
        setupTitle()
    }
    
    private func setupTableView() {
        
        sceneTableView.backgroundColor = UIColor.clear
        sceneTableView.tableFooterView = UIView()
    }
    
    private func setupTitle() {
        
        sceneTitleLabel.font = UIFont.defaultFont(style: .medium, size: .large)
        sceneTitleLabel.textColor = Colors.textDefault
    }
    
    // MARK: - Data integration
    
    private func distributeScene() {
        
        guard scene != nil else {return}
        
        let _title = String(format: Strings.navigationTitleFormatScene, scene.id)
        title = title
        sceneTitleLabel.text = _title
        coverImageView.image = scene.image
        
        sceneTableView.contentInset = UIEdgeInsets(top: scene.image != nil ? coverImageView.bounds.size.height - 50 : 0, left: 0, bottom: 0, right: 0)
        
        if scene.playerDied, !GameData.shared.player.isDead {
            GameData.shared.player.die()
            sceneTableView.reloadData()
        }
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
                let waypoint = WayPoint(direction: .back, destination: lastScene.sceneId, caption: Strings.goBack)
                waypoints = [waypoint]
                actions = nil
                sceneTableView.reloadData()
            }
        }
    }
    
    private func sceneChanged() {
        
        distributeScene()
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
        case .restart:
            return GameData.shared.player == nil || GameData.shared.player.isDead ? 1 : 0
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
            case .restart:
                if GameData.shared.player != nil && GameData.shared.player.isDead {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "restartCell")
                    cell.textLabel?.text = Strings.restartGame
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
        
        if section == .waypoints {
            
            if let waypoints = waypoints, indexPath.row < waypoints.count {
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
                        self.distributeScene()
                        self.sceneTableView.reloadData()
                    }
                }))
                alert.addAction(UIAlertAction.cancelAction())
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
        else if section == .restart {
            
            restartGame()
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
                let alert = UIAlertController.simpleMessageAlert(message: Strings.messageWaypointNotSelectable)
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
        else if action.type == .gamble, let _action = action as? GambleAction {
            gamble(_action)
        }
        else if action.type == .query, let _action = action as? QueryAction {
            query(_action)
        }
        else if action.type == .trade, let _action = action as? TradeAction {
            trade(_action)
        }
    }
    
    private func tryLuck(_ action: TryLuckAction) {
                
        let luck = GameData.shared.player.tryLuck()
        
        var message = String(format: Strings.messageFormatRoll, luck.rolled, luck.success ? Strings.goodLuck : Strings.badLuck)
        
        if action.rollWinsMoney || action.rollLoseMoney {
            
            let money = Money(amount: luck.rolled)
            if luck.success, action.rollWinsMoney {
                GameData.shared.player.add(inventoryItem: money)
                message = String(format: Strings.messageFormatGainedGold, luck.rolled)
            }
            else if !luck.success, action.rollLoseMoney {
                GameData.shared.player.pay(amount: luck.rolled)
                message = String(format: Strings.messageFormatLostGold, luck.rolled)
            }
        }
                
        let alert = UIAlertController(title: Strings.titleTriedLuck, message: message, preferredStyle: .alert)
        
        if luck.success {
            alert.addAction(UIAlertAction(title: action.goodLuck.caption, style: .default, handler: { (_) in
                
                if luck.success, let _choices = action.goodLuckRolls, let choice = _choices.first(where: {$0.roll == luck.rolled}) {
                    // Special roll action
                    if let _waypoint = choice.waypoint {
                        self.advance(to: _waypoint)
                    }
                    else if let _action = choice.action {
                        self.perform(action: _action)
                    }
                }
                else {
                    // Standard good luck
                    self.advance(to: action.goodLuck)
                }
            }))
        }
        else {
            alert.addAction(UIAlertAction(title: action.badLuck.caption, style: .default, handler: { (_) in
                
                if !luck.success, let _choices = action.badLuckRolls, let choice = _choices.first(where: {$0.roll == luck.rolled}) {
                    // Special roll action
                    if let _waypoint = choice.waypoint {
                        self.advance(to: _waypoint)
                    }
                    else if let _action = choice.action {
                        self.perform(action: _action)
                    }
                }
                else {
                    // Standard bad luck
                    self.advance(to: action.badLuck)
                }
            }))
        }
        
        present(alert, animated: true) {
            GameData.shared.completed(scene: self.scene)
        }
    }
    
    private func fight(_ fight: FightAction) {
        
        performSegue(withIdentifier: Segues.fight, sender: fight)
    }
    
    private func trade(_ action: TradeAction) {
        
        performSegue(withIdentifier: Segues.trade, sender: action)
    }
    
    private func advance(to wayPoint: WayPoint) {
        
        // Check conditions
        if let condition = wayPoint.condition, !GameData.shared.player.isFulfilled(condition: condition) {
            waypointConditionNotfulfilled()
            return
        }
        
        // Check if waypoint is fallback
        if wayPoint.condition?.onlyWhenNoFights ?? false {
        
            var pendingFights = false
            
            let fights = actions?.filter({ (_action) -> Bool in
                return _action.type == .fight
            })
            
            if let _fights = fights {
                for fight in _fights {
                    if let _fight = fight as? FightAction {
                        for opponent in _fight.opponents {
                            if !opponent.isDead {
                                pendingFights = true
                                break
                            }
                        }
                    }
                }
            }
            
            if pendingFights {
                waypointConditionNotfulfilled()
                return
            }
        }
        
        // Only when visited before
        if let _sceneId = wayPoint.condition?.onlyWhenVisited, !GameData.shared.isCompleted(sceneId: _sceneId) {
            waypointConditionNotfulfilled()
            return
        }
        
        // Only when NOT visited before
        if let _sceneId = wayPoint.condition?.onlyWhenNotVisited, GameData.shared.isCompleted(sceneId: _sceneId) {
            waypointConditionNotfulfilled()
            return
        }
        
        advance(to: wayPoint.destination)
    }
    
    private func waypointConditionNotfulfilled() {
        
        let alert = UIAlertController.simpleMessageAlert(message: Strings.messageWaypointNotSelectable)
        present(alert, animated: true, completion: nil)
    }
    
    private func advance(to sceneId: Int) {
        
        guard let _scene = GameData.shared.game.scene(id: sceneId) else {return}
        guard GameData.shared.player != nil, !GameData.shared.player.isDead else {return}
                
        GameData.shared.advance(player: GameData.shared.player, scene: _scene)
        GameData.shared.completed(scene: scene)
        
        scene = _scene
        distributeScene()
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
            let _action = UIAlertAction(title: Strings.buttonTitleRolAgain, style: .default) { (_) in
                self.roll(action)
            }
            actions.append(_action)
        }
        
        let alert = UIAlertController(title: Strings.roll, message: String(format: Strings.messageFormatRolled, roll), preferredStyle: .alert)
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
            self.distributeScene()
            self.sceneTableView.reloadData()
        }
        
        let alert = FightViewController.escapeDialog(withTryLuck: {
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
        distributeScene()
        sceneTableView.reloadData()
    }
    
    private func propertyRoll(_ action: PropertyRollAction) {
                
        let roll = PropertyRoll(character: GameData.shared.player, action: action).roll()
        
        let alert = UIAlertController(title: Strings.roll, message: String(format: Strings.messageFormatRolled, roll.roll), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: roll.waypoint.caption, style: .default, handler: { (_) in
            self.advance(to: roll.waypoint)
        }))
        GameData.shared.player.log(event: .roll(value: roll.roll))
        
        present(alert, animated: true) {
            GameData.shared.completed(scene: self.scene)
        }
    }
    
    private func query(_ action: QueryAction) {
        
        guard GameData.shared.player != nil else {return}
        
        let query = Query(action: action)
        queryAnswer(for: query)
    }
    
    private func queryAnswer(for query: Query) {
        
        guard GameData.shared.player != nil else {return}
        
        let alert = UIAlertController(title: query.action.caption, message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = Strings.placeholderQueryAnswer
        }
        alert.addAction(UIAlertAction.OKAction(title: nil, selected: {
            if let answer = alert.textFields?.first?.text?.nilIfEmpty {
                if query.check(answer: answer), let sceneId = Int(answer), let _ = GameData.shared.game.scene(id: sceneId) {
                    GameData.shared.player.log(event: .answered(question: query.action.caption, answer: answer, correct: true))
                    self.advance(to: sceneId)
                }
                else {
                    GameData.shared.player.log(event: .answered(question: query.action.caption, answer: answer, correct: false))
                    self.queryAnswer(for: query)
                }
            }
            else {
                GameData.shared.player.log(event: .answered(question: query.action.caption, answer: "\"\"", correct: false))
                self.queryAnswer(for: query)
            }
        }))
        alert.addAction(UIAlertAction.cancelAction(title: nil, selected: {
            self.advance(to: query.action.cancel)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func restartGame() {
        
        guard GameData.shared.player != nil, GameData.shared.player.isDead else {return}
        guard GameData.shared.game != nil, let firstSceneId = GameData.shared.game.firstScene?.id else {return}
        
        let alert = UIAlertController(title: Strings.titleFinished, message: Strings.messageGameFinished, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.buttonTitleRestartSameChar, style: .default, handler: { (_) in
            GameData.shared.reset()
            GameData.shared.player.reset()
            self.advance(to: firstSceneId)
        }))
        alert.addAction(UIAlertAction(title: Strings.buttonTitleRestartNewChar, style: .destructive, handler: { (_) in
            GameData.shared.reset()
            GameData.shared.player = nil
            self.navigationController?.popToRootViewController(animated: false)
        }))
        alert.addAction(UIAlertAction.cancelAction())
        
        present(alert, animated: true, completion: nil)
    }
    
    private func gamble(_ action: GambleAction) {
        
        guard GameData.shared.player != nil else {return}
        
        let gamble = Gamble(action: action, player: GameData.shared.player)
        
        queryBetAmount { (bet) in
            
            if bet > 0 {
                self.roll(gamble: gamble, bet: bet)
            }
            else {
                self.advance(to: action.finish)
            }
        }
    }
    
    private func queryBetAmount(completion: @escaping ((_ amount: Int) ->())) {
        
        let alert = UIAlertController(title: Strings.titleBetGamble, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = Strings.placeholderBet
        }
        alert.addAction(UIAlertAction(title: Strings.titleGamble, style: .default, handler: { (_) in
            if let _textField = alert.textFields?.first, let _betString = _textField.text?.nilIfEmpty, let bet = Int(_betString), bet > 0, bet <= GameData.shared.player.money {
                completion(bet)
            }
            else {
                self.queryBetAmount(completion: completion)
            }
        }))
        alert.addAction(UIAlertAction.cancelAction(selected: {
            completion(0)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func roll(gamble: Gamble, bet: Int) {
        
        let roll = gamble.roll()
        
        if roll.win {
            
            let money = Money(amount: bet)
            GameData.shared.player.add(inventoryItem: money)
            
            if gamble.rounds == 1, let _bonuses = gamble.action.winBonus {
                for bonus in _bonuses {
                    GameData.shared.player.apply(bonus: bonus)
                }
            }
        }
        else {
            GameData.shared.player.pay(amount: bet)
        }
        
        let title = roll.win ? Strings.titleGambleWon : Strings.titleGableLost
        var message = String(format: Strings.messageFormatGableRoll, roll.playerRoll, roll.opponentRoll)
        message += "\n"
        message += String(format: (roll.win ? Strings.messageFormatGambleWin : Strings.messageFormatGambleLost), bet)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if GameData.shared.player.money > 0 {
            alert.addAction(UIAlertAction(title: Strings.buttonTitleAnotherRound, style: .default, handler: { (_) in
                alert.dismiss(animated: true) {
                    self.queryBetAmount { (bet) in
                        if bet > 0 {
                            self.roll(gamble: gamble, bet: bet)
                        }
                        else {
                            self.advance(to: gamble.action.finish)
                        }
                    }
                }
            }))
        }
        alert.addAction(UIAlertAction(title: Strings.titleFinished, style: .cancel, handler: { (_) in
            self.advance(to: gamble.action.finish)
        }))
        
        present(alert, animated: true, completion: nil)
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
        else if segue.identifier == Segues.trade, let navController = segue.destination as? UINavigationController, let destination = navController.viewControllers.first as? TradeViewController, let trade = sender as? TradeAction {
            
            destination.action = trade
        }
    }
    
    private func playerDied() {
        
        let alert = UIAlertController.simpleMessageAlert(message: Strings.messagePlayerDied, title: Strings.sorry) {
            // FIXME: Proceed to dead screen
        }
        present(alert, animated: true, completion: nil)
    }
    
    private func rest(_ action: RestAction) {
        
        guard GameData.shared.player != nil else {return}
        
        GameData.shared.player.rest(health: action.health, dexterity: action.dexterity)
        
        let alert = UIAlertController(title: Strings.titleResting, message: Strings.messageResting, preferredStyle: .alert)
        for waypoint in action.finished {
            alert.addAction(UIAlertAction(title: waypoint.caption, style: .default, handler: { (_) in
                self.advance(to: waypoint)
            }))
        }
        
        present(alert, animated: true, completion: nil)
    }
}
