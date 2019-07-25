//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 25/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire

class ShowDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TVShowName: UILabel!
    @IBOutlet weak var TVShowDescription: UILabel!
    @IBOutlet weak var addEpisodeButton: UIButton!
    @IBOutlet weak var episodeNumber: UILabel!
    
    // MARK: - Properties
    
    var loggedUser = ""
    var showID = ""
    private var items = [ShowEpisode]()
    private var showDetails : ShowDetails?

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupTableView()
        _getShowDetails(token: loggedUser, idShow: showID)
    }
    
    // MARK: - Private functions
    
    private func configureUI() {
        addEpisodeButton.layer.cornerRadius = 0.5 * addEpisodeButton.bounds.size.width
        addEpisodeButton.clipsToBounds = true
    }
    
}

// MARK: - UITableView
extension ShowDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        print("Selected Item: \(item)")
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EpizodeDetailsTableViewCell.self), for: indexPath) as! EpizodeDetailsTableViewCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

//MARK: - Private
private extension ShowDetailsViewController {
    func setupTableView() {
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Get show details
private extension ShowDetailsViewController {
    
    func _getShowDetails(token: String, idShow: String) {
        let headers = ["Authorization": token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows/\(idShow)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<ShowDetails>) in
                switch response.result {
                case .success(let response):
                    //print( "Success: \(response)")
                    guard let self = self else { return }
                    self.showDetails = response
                    self.TVShowName.text = response.title
                    self.TVShowDescription.text = response.description
                    self._getShowEpizodes(token: token, idShow: idShow)
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
}

// MARK: - Get show episodes
private extension ShowDetailsViewController {
    
    func _getShowEpizodes(token: String, idShow: String) {
        let headers = ["Authorization": token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows/\(idShow)/episodes",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[ShowEpisode]>) in
                switch response.result {
                case .success(let response):
                    //print( "Success: \(response)")
                    guard let self = self else { return }
                    self.items = response
                    self.episodeNumber.text = String(self.items.count)
                    self.tableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
}
