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
import Kingfisher

final class ShowDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TVShowName: UILabel!
    @IBOutlet weak var TVShowDescription: UILabel!
    @IBOutlet weak var addEpisodeButton: UIButton!
    @IBOutlet weak var episodeNumber: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
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
    
    // MARK: - Actions
    
    @IBAction func addNewEpisode(_ sender: Any) {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Home", bundle: bundle)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "AddEpisodeViewController"
            ) as! AddEpisodeViewController
        
        vc.showID = showID
        vc.loggedUser = loggedUser
        
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true)
    }
    
    @IBAction func pressBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private functions
    
    private func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        addEpisodeButton.layer.cornerRadius = 0.5 * addEpisodeButton.bounds.size.width
        addEpisodeButton.clipsToBounds = true
        backButton.layer.cornerRadius = 0.5 * backButton.bounds.size.width
        backButton.clipsToBounds = true
    }
    
    private func setImage(imageUrl: String){
        let url = URL(string: "https://api.infinum.academy" + imageUrl)
        if imageUrl.isEmpty {
            showImage.image = UIImage(named: "icImagePlaceholder")
        }else{
           showImage.kf.setImage(with: url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addEpisodeVC = segue.destination as? AddEpisodeViewController {
            addEpisodeVC.delegate = self
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EpisodeDetailsTableViewCell.self), for: indexPath) as! EpisodeDetailsTableViewCell
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
                    self.setImage(imageUrl: response.imageUrl)
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

extension ShowDetailsViewController: AddEpisodeViewControllerDelegate {
    func didAddNewEpisodes() {
        tableView.reloadData()
    }
    
   
}
