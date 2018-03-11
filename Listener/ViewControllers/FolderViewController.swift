//
//  FolderViewController.swift
//  Listener
//
//  Created by Chunbo Hu on 2018/3/11.
//  Copyright © 2018年 Chunbo Hu. All rights reserved.
//

import UIKit

class FolderViewController: UIViewController {
    
    let fileManager = FileManager.default
    var folderURL:URL? = nil
    let folderTableViewController = FolderTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFolderURL()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listFiles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupFolderURL() {
        if folderURL != nil {return}
        folderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func setupViews() {
        title =  convertPathToFolderName(path: folderURL!.path) ?? "Folder Browser"
        view.backgroundColor = UIColor.white
        
        self.addChildViewController(folderTableViewController)
        folderTableViewController.view.frame = view.frame
        view.addSubview(folderTableViewController.view)
        
        view.autoresizesSubviews = true
        self.edgesForExtendedLayout = .init(rawValue: 0)
    }
    
    private func listFiles() {
        guard let folderURL = folderURL else {return}
        do {
            var fileURLs = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            print(fileURLs)
            
            // filter files
            fileURLs = fileURLs.filter({ (fileURL: URL) -> Bool in
                var needToKeep: Bool = true
                
                // filter .hidden files
                /*
                if fileURL.path.hasPrefix(".") {
                    return false
                }
                */
                
                // filiter .mp3 files
                if !hasFolderInFileList(fileList: fileURLs) {
                    needToKeep = fileURL.path.hasSuffix(".mp3")
                }
                return needToKeep
            })
            
            folderTableViewController.models = fileURLs
        } catch {
            print("Error while enumerating files \(folderURL.path): \(error.localizedDescription)")
        }
    }
    
    private func hasFolderInFileList(fileList: [URL]) -> Bool {
        for fileItem in fileList {
            if fileItem.isDirectory {
                return true
            }
        }
        return false
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
    
    private func convertPathToFolderName(path: String) -> String? {
        let matchedFolderNames = matches(for: "[^/]+$", in: path)
        if (matchedFolderNames.count > 0) {
            return matchedFolderNames.first!
        }
        return nil
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
