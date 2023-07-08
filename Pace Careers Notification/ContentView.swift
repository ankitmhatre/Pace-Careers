import SwiftUI
import Foundation

let urlString = "https://careers.pace.edu/postings/search.atom"
var components = URLComponents(string: urlString)

struct ContentView: View {
    @State private var entryItems: [Entry] = []
    
    var body: some View {
        NavigationView {
            List(entryItems, id: \.id) { item in
          
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                        Text("published \(formattedDate(item.updated))")
                            .font(.subheadline)
                        Text("updated \(formattedDate(item.updated))")
                            .font(.subheadline)
                        Text(item.content)
                            .font(.subheadline)
                    }
                    .onTapGesture {
                        let url = URL(string: item.id)!
                                   openURL(url)
                    }
                }
            .navigationTitle("Pace Careers")
           
            
        }
        .onAppear {
            fetchRSSFeed()
        }
    }
    
    func openURL(_ url: URL) {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
       }
    
    func  formattedDate(_ dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        

        if let date = dateFormatter.date(from: dateString) {
            let readableDateFormatter = DateFormatter()
            readableDateFormatter.dateFormat = "d MMM,  h:mm a"
            let readableDateString = readableDateFormatter.string(from: date)
            
           return readableDateString
        } else {
            return dateString
        }
    }
    
    func fetchRSSFeed() {
           guard let url = URL(string: "https://careers.pace.edu/postings/search.atom?query=&query_v0_posted_at_date=&query_position_type_id[]=5&435=&1543[]=3&commit=Search") else {
               return
           }
           
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data else {
                   if let error = error {
                       print("Error fetching RSS feed: \(error.localizedDescription)")
                   }
                   return
               }
               
               let xmlParserDelegate = XMLParserDelegateImpl()
               xmlParserDelegate.parseXMLData(data: data)
               
               let entries = xmlParserDelegate.entries
               self.entryItems = entries
//               for entry in entries {
//                   
//                   print("ID: \(entry.id)")
//                   print("Title: \(entry.title)")
//                   print("Updated: \(entry.updated)")
//                   print("---")
//               }
               
               DispatchQueue.main.async {
                   // Update UI with parsed entries if needed
               }
           }
           task.resume()
       }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





