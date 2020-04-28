//
//  LogViewController.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 28/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class LogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var logTableView: UITableView!
    
    private let cellReuseId = "logCell"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - UI customization
    
    private func setupUI() {
        
        view.backgroundColor = Colors.defaultBackground
        logTableView.tableFooterView = UIView()
        logTableView.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        logTableView.reloadData()
    }
    
    // MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return GameData.shared.player != nil ? GameData.shared.player.log.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LogCell.reuseId, for: indexPath) as? LogCell else {return UITableViewCell()}
        
        let item = GameData.shared.player.log[indexPath.row]
        cell.setup(item: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
