//
//  AddEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum on 25/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire

protocol AddEpisodeViewControllerDelegate: class {
    func didAddNewEpisodes()
}

final class AddEpisodeViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var episodeTitleField: UITextField!
    @IBOutlet weak var seasonNumberField: UITextField!
    @IBOutlet weak var episodeNumberField: UITextField!
    @IBOutlet weak var episodeDescriptionField: UITextField!
    
    // MARK: - Properties
    weak var delegate: AddEpisodeViewControllerDelegate?
    var loggedUser = ""
    var showID = ""
    
    //MARK: - Lifecycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(didSelectAddShow)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didSelectCancel)
        )
        configureUI()
    }
    
    @objc func didSelectAddShow() {
        guard
            let title = episodeTitleField.text,
            let description = episodeDescriptionField.text,
            let episodeNumber = episodeNumberField.text,
            let seasonNumber = seasonNumberField.text,
            !title.isEmpty,
            !description.isEmpty,
            !episodeNumber.isEmpty,
            !seasonNumber.isEmpty
            else {
                return
        }
        _addNewEpisode(token: loggedUser, showId: showID, mediaId: "", title: title, description: description, episodeNumber: episodeNumber, seasonNumber: seasonNumber)
    }
    
    @objc func didSelectCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private functions
    
    private func configureUI(){
        navigationController?.navigationBar.tintColor = UIColor.red
    }
    
    private func showAlert(title: String,  message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true) {
        }
    }
}

// MARK: - Add new episode

private extension AddEpisodeViewController {
    
    func _addNewEpisode(token: String, showId: String, mediaId: String, title: String, description: String, episodeNumber: String, seasonNumber: String) {
        let headers = ["Authorization": token]
        let parameters: [String: String] = [
            "showId": showId,
            "mediaId": mediaId,
            "title": title,
            "description": description,
            "episodeNumber": episodeNumber,
            "season": seasonNumber
        ]
        Alamofire
            .request(
                "https://api.infinum.academy/api/episodes",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (response: DataResponse<NewEpisode>) in
                switch response.result {
                case .success(let episode):
                    guard let self = self else { return }
                    print("Success: \(episode)")
                    self.delegate?.didAddNewEpisodes()
                    self.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    print("API failure: \(error)")
                    self!.showAlert(title: "API add episode failure", message: "\(error)")
                }
        }
    }
}
