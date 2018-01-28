//
//  ViewController.swift
//  CodingChallengeHiddenFounders
//
//  Created by Gotzon Zabala on 25/1/18.
//  Copyright © 2018 Gotzon Zabala. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet var reposTableOutlet: UITableView!
    
    var repositories = 0
    var repoName = [String]()
    var repoDescription = [String]()
    var ownerImageUrl = [String]()
    var ownerName = [String]()
    var totalStars = [Float]()

    
   
    struct GitHubDescription: Decodable {
        let items: [GitHub]
    }
    
    struct Owner: Decodable {
        let login: String
        let avatar_url: String
    }

    struct GitHub: Decodable {
        let name: String
        let owner: Owner
        let description: String?
        let stargazers_count: Float
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiTask()
    
        
       
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func apiTask() {
        
        let jsonUrl = "https://api.github.com/search/repositories?q=created:%3E2017-10-22&sort=stars&order=desc&page=1"
        guard let url = URL(string: jsonUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            
            do {
                
                let repos = try JSONDecoder().decode(GitHubDescription.self, from: data)
                
                DispatchQueue.main.sync {
                    
                    self.repositories = repos.items.count - 1
                    
                    for x in 0...self.repositories{     //to enter data on the arrays
                        
                        self.repoName.append(repos.items[x].name)
                        
                            if repos.items[x].description == nil{
                                self.repoDescription.append("")
                            }else{
                                self.repoDescription.append(repos.items[x].description!)
                            }
                        
                        self.ownerImageUrl.append(repos.items[x].owner.avatar_url)
                        self.ownerName.append(repos.items[x].owner.login)
                        self.totalStars.append(repos.items[x].stargazers_count)
                        
                    }
                    self.reposTableOutlet.reloadData()
                }
                
                
            } catch let jsonError {
                
                print("Error serializing json:", jsonError)
                
            }
            
            
            
            }.resume()
    }
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
        return repositories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellTable = tableView.dequeueReusableCell(withIdentifier: "RepoCellTable", for: indexPath) as! RepoTableViewCell
        
        let index = indexPath.row
    
        cellTable.repoName.text = repoName[index]
        cellTable.repoDescription.text = repoDescription[index]
        cellTable.ownerImage.downloadedFrom(link: ownerImageUrl[index])
        cellTable.ownerName.text = ownerName[index]
        
        if totalStars[index] > 1000 {
        
            let stars = totalStars[index] / 1000

            cellTable.totalStars.text = "\(String(NSString(format: "%.01f", stars)))k"
        }else{
            cellTable.totalStars.text = "\(Int(totalStars[index]))"
        }
        
        
        return cellTable
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame: CGRect = tableView.frame
        
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        let textHeader: UILabel = UILabel(frame: CGRect(x: 0, y: 10, width: view.frame.width, height: 50))
        if ownerName.isEmpty == false {
            textHeader.text = "Trending Repos"
            headerView.backgroundColor = UIColor.gray
        }
        
        textHeader.textAlignment = NSTextAlignment.center

        
        headerView.addSubview(textHeader)
        
        return headerView
    }

   

}

//This is an extension to show the image from a url.

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

