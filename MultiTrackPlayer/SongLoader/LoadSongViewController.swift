//
//  LoadSongViewController.swift
//  AnikaApp
//
//  Created by Patrick Rugebregt on 04/02/2022.
//

import UIKit

class LoadSongViewController: UIViewController {

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
    
}

extension LoadSongViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSong = songs[indexPath.row]
    }
}

extension LoadSongViewController: UITableViewDataSource {
    
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
