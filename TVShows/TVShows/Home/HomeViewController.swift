//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum on 16/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire


final class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var loggedUser = ""
    
    // MARK: - Priavate
    private var items = [TVShowItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _getShows(token: loggedUser)
        setupTableView()
    }
    
}

// MARK: - UITableView
extension HomeViewController: UITableViewDelegate {
    // Delegate UI events, open up `UITableViewDelegate` and explore :)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        print("Selected Item: \(item)")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TVShowsTableViewCell.self), for: indexPath) as! TVShowsTableViewCell
        
        cell.configure(with: items[indexPath.row])

        return cell
    }
    
    
}

//MARK: - Private
private extension HomeViewController {
    func setupTableView() {
       
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - get TVShows

private extension HomeViewController {
    
    func _getShows(token: String) {
        let headers = ["Authorization": token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows/",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<[TVShowItem]>) in
                switch response.result {
                case .success(let response):
                    print( "Success: \(response)")
                    self.items = response
                    self.tableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                    
                }
        }
    }
    
}

