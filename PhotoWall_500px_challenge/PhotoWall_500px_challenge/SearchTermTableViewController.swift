//
//  SearchTermTableViewController.swift
//  PhotoWall_500px_challenge
//
//  Created by Jianxiong Wang on 2/11/17.
//  Copyright © 2017 JianxiongWang. All rights reserved.
//

import UIKit

protocol SearchTermDelegate:class {
    func searchTermDidChange(sender: SearchTermTableViewController, newTerm: String)
}

class SearchTermTableViewController: UITableViewController {

    weak var delegate:SearchTermDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Select Category"
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CATEGORIES.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = CATEGORIES[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchTermDidChange(sender: self, newTerm: CATEGORIES[indexPath.row])
        _ = self.navigationController?.popViewController(animated: true)
    }

}
