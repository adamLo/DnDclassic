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
    
    var game: Game!
    var scene: Scene!
    
    private enum Section: Int, CaseIterable {
        
        case story = 0, waypoints
    }
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
        distributeGame()
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
        
        guard game != nil else {return}
        
        let _title = String(format: NSLocalizedString("Scene %d", comment: "Scene navigation title format"), scene.id)
        title = title
        sceneTitleLabel.text = _title
        coverImageView.image = scene.image
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
            return scene.wayPoints?.count ?? 0
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
}
