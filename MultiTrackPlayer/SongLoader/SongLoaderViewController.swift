//
//  LoadSongViewController.swift
//  AnikaApp
//
//  Created by Patrick Rugebregt on 04/02/2022.
//

import UIKit

class SongLoaderViewController: UIViewController {

    @IBOutlet weak var songTableView: UITableView!
    @IBOutlet weak var loadButton: UIButton!
    
    private let songLoader = SongLoader()
    private let musicPlayer = MusicPlayer.shared
    private var songs : [Song] {
        return SongList().songs
    }
    private var chosenSong: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songLoader.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(songWasLoaded), name: .loadNewTrack, object: nil)
        songTableView.delegate = self
        songTableView.dataSource = self
    }
    
    @objc func songWasLoaded() {
        let alert = UIAlertController(title: "\(chosenSong?.title ?? "Song")", message: "Your song has been loaded", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { alert in
            DispatchQueue.main.async {
                self.tabBarController!.selectedIndex = 0
            }
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func loadButtonPressed(_ sender: Any) {
        guard let chosenSong = chosenSong else { return }
        musicPlayer.removeAllTracks()
        songLoader.changeSong(to: chosenSong)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension SongLoaderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSong = songs[indexPath.row]
    }
}

extension SongLoaderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = songs[indexPath.row].title
        cell?.detailTextLabel?.text = songs[indexPath.row].artist
        return cell!
    }
    
}
