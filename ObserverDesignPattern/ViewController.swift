//
//  ViewController.swift
//  ObserverDesignPattern
//
//  Created by Sivaramaiah NAKKA on 02/11/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// points in observer pattern.
// 1. Pub-Sub model
// 2. Sub must follow some common methods for that we use one protocol
//'3. Pub has array of observables references.
// 4. Pub will notify the observabers by calling their methods.


protocol DownloadManagerDelegate {
    func urlSessionNew(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
}

protocol Observable {
    func didReceiveError(error: Error)
    func update()
}

enum DownloadState {
    case downloadComplete
    case downloadError(Error)
}


class DownloadManager: DownloadManagerDelegate {
    
    static let shared: DownloadManager = DownloadManager()
    
    private var observers: [Observable] = []
    
    func addObserver(observer: Observable) {
        observers.append(observer)
    }
    
    func removeObserver(observer: Observable) {
        // Logic to remove observer
    }
    
    func notifyObservers(downloadState: DownloadState) {
        
        for observer in observers {
            switch downloadState {
            case .downloadComplete:
                observer.update()
            case .downloadError(let error):
                observer.didReceiveError(error: error)
            }
        }
    }
    
    func urlSessionNew(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        notifyObservers(downloadState: .downloadError(error!))
    }
}


class MyDownloads: Observable {
    
    init() {
        DownloadManager.shared.addObserver(observer: self)
    }
    
    func update() {
        
    }
    
    func didReceiveError(error: Error) {
        print("Eror:", error.localizedDescription)
    }
}

