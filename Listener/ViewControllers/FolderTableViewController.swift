//
//  FolderTableViewController.swift
//  Listener
//
//  Created by Chunbo Hu on 2018/3/11.
//  Copyright © 2018年 Chunbo Hu. All rights reserved.
//

import UIKit

class FolderTableViewController: UITableViewController {
    
    var models: [URL] = [URL]()
    let defaultIdentifier: String = "defaultCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViews() {
        self.clearsSelectionOnViewWillAppear = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultIdentifier)
    }
    
    private func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    private func convertPathToFolderName(path: String) -> String {
        let matchedFolderNames = matches(for: "[^/]+$", in: path)
        if (matchedFolderNames.count > 0) {
            return matchedFolderNames.first!
        }
        return ""
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return models.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultIdentifier, for: indexPath)

        let currentURL = models[indexPath.row]
        let currentPath = currentURL.path
        cell.textLabel?.text =  (currentURL.isDirectory ? "[Folder] " : "") + convertPathToFolderName(path: currentPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentPath = models[indexPath.row].path
        print(currentPath)
        
        loadSubPathFolder(targetPath: models[indexPath.row])
    }
    
    private func loadSubPathFolder(targetPath: URL) {
        guard isFolderForURL(url: targetPath) else {return}
        
        let targetFolderVC = FolderViewController()
        targetFolderVC.folderURL = targetPath
        self.parent?.navigationController?.pushViewController(targetFolderVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}