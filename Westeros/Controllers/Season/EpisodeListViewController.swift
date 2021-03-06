//
//  EpisodeListViewController.swift
//  Westeros
//
//  Created by Eric Sans Alvarez on 18/02/2019.
//  Copyright © 2019 Eric Sans Alvarez. All rights reserved.
//

import UIKit

class EpisodeListViewController: UITableViewController {
    
    var model: [Episode]
    
    init(model: [Episode]) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        title = "Episodes"
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        print("EpisodeList has been deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.seasonDidChange(notification:)), name: Notification.Name(Const.seasonDidChangeNotificationName.rawValue), object: nil)
        //tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    @objc func seasonDidChange(notification: Notification) {
        guard let info = notification.userInfo,
            let season = info[Const.seasonKey.rawValue] as? Season else { return }
        model = season.sortedEpisodes
        tableView.reloadData()
        let backButton = UIBarButtonItem(title: season.name, style: .plain, target: self, action: Selector(("none")))
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let episode = model[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "EpisodeCell")
        }

        // Configure the cell...
        cell?.textLabel?.text = episode.title
        cell?.detailTextLabel?.text = "\(episode.airDate.strFromDate())"

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = model[indexPath.row]
        
        let nextScreen = EpisodeDetailViewController(model: episode)
        
        navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
