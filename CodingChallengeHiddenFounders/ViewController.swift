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
    var totalStars = [Int]()

   
    struct GitHubDescription: Decodable {
     //   let total_count: Int
        let items: [GitHub]
        
    }
    struct Owner: Decodable {
        let login: String
        let avatar_url: String
    }

    struct GitHub: Decodable {
        let name: String
      //  let description: String
       // let login: String
        let owner: Owner
        let description: String?
        let stargazers_count: Int
        
        /*
        init(json: [String: Any]) {
            repoName = json["name"] as? String ?? ""
            repoDescription = json["description"] as? String ?? ""
            ownerName = json["tipsy"] as? String ?? ""
            numberStars = json["stargazers_count"] as? Int ?? -1
            
        }
 */
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        let jsonUrl = "https://api.github.com/search/repositories?q=created:%3E2017-10-22&sort=stars&order=desc"
        guard let url = URL(string: jsonUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //Check error
            //Check response status
            
            guard let data = data else { return }
            
            
            do {
                
                let repos = try JSONDecoder().decode(GitHubDescription.self, from: data)
            
                
              
                print(repos.items[0])
                
                
                
                
             //   self.repoDescription = repos.items[0].description as? String ?? ""
              
                
            
                DispatchQueue.main.sync {
                    
                    self.repositories = repos.items.count - 1
                    
                    for x in 0...self.repositories{
                        self.repoName.append(repos.items[x].name)
                        if repos.items[x].description == nil{
                            self.repoDescription.append("")
                        }else{
                            self.repoDescription.append(repos.items[x].description!)
                        }
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
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
        return repositories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellTable = tableView.dequeueReusableCell(withIdentifier: "RepoCellTable", for: indexPath) as! RepoTableViewCell
        
        let index = indexPath.row
        
        cellTable.repoName.text = repoName[index]
        cellTable.repoDescription.text = repoDescription[index]
     //   cellTable.ownerImage
        cellTable.ownerName.text = ownerName[index]
        cellTable.totalStars.text = "\(totalStars[index])"
        
        return cellTable
    }


}

