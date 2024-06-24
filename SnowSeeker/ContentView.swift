//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Héctor Manuel Sandoval Landázuri on 10/06/24.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
////        NavigationView {
////            Text("Hello, world!")
////                .navigationTitle("Primary")
////        }
////      NavigationSplitView(columnVisibility: .constant(.all)) {
//        NavigationSplitView(preferredCompactColumn: .constant(.detail)) {
//
//            NavigationLink("Primary") {
//                Text("New view")
//            }
//        } detail: {
//            Text("Content")
//                .navigationTitle("Content View")
//        }
//        .navigationSplitViewStyle(.balanced)
//    }
//}

//struct User: Identifiable {
//    var id = "Taylor Swift"
//}
//
//struct ContentView: View {
//    @State private var selectedUser: User? = nil
//    @State private var isShowingUser = false
//    var body: some View {
//        Button("Tap Me") {
//            selectedUser = User()
//            isShowingUser = true
//        }
//        .sheet(item: $selectedUser) { user in
//            Text(user.id)
//                .presentationDetents([.medium, .large])
//        }
////        .alert("Welcome", isPresented: $isShowingUser, presenting: selectedUser) { user in
////            Button(user.id) { }
////        }
//    }
//}

//struct UserView: View {
//    var body: some View {
//        Group {
//            Text("Name: Paul")
//            Text("Country: England")
//            Text("Pets: Luna and Arya")
//        }
//        .font(.title)
//    }
//}

//struct ContentView: View {
//    @State private var layoutVertically = false
//
//    var body: some View {
//        Button {
//            layoutVertically.toggle()
//        } label: {
//            if layoutVertically {
//                VStack {
//                    UserView()
//                }
//            } else {
//                HStack {
//                    UserView()
//                }
//            }
//        }
//    }
//}

//struct ContentView: View {
//    @Environment(\.horizontalSizeClass) var horizontalSizeClass
//
//    var body: some View {
//        if horizontalSizeClass == .compact {
//            VStack {
//                UserView()
//            }
//        } else {
//            HStack {
//                UserView()
//            }
//        }
//    }
//}

//struct ContentView: View {
//    @Environment(\.horizontalSizeClass) var horizontalSizeClass
//
//    var body: some View {
//        ViewThatFits {
//            Rectangle()
//                .frame(width: 500, height: 200)
//
//            Circle()
//                .frame(width: 200, height: 200)
//        }
//    }
//}

//struct ContentView: View {
//    @State private var searchText = ""
//
//    var body: some View {
//        NavigationStack {
//            Text("Searching for \(searchText)")
//                .searchable(text: $searchText, prompt: "Look for something")
//                .navigationTitle("Searching")
//        }
//    }
//}

//struct ContentView: View {
//    @State private var searchText = ""
//    let allNames = ["Subh", "Vina", "Melvin", "Stefanie"]
//
//    var filteredNames: [String] {
//        if searchText.isEmpty {
//            allNames
//        } else {
//            allNames.filter { $0.localizedStandardContains(searchText) }
//        }
//    }
//
//    var body: some View {
//        NavigationStack {
//            List(filteredNames, id: \.self) { name in
//                Text(name)
//            }
//            .searchable(text: $searchText, prompt: "Look for something")
//            .navigationTitle("Searching")
//        }
//    }
//}

//@Observable
//class Player {
//    var name = "Anonymous"
//    var highScore = 0
//}
//
//struct HighScoreView: View {
//    @Environment(Player.self) var player
//
//    var body: some View {
//        @Bindable var player = player
//        Stepper("High score: \(player.highScore)", value: $player.highScore)
//    }
//}
//
//struct ContentView: View {
//    @State private var player = Player()
//    
//    var body: some View {
//        VStack {
//            Text("Welcome!")
//            HighScoreView()
//        }
//        .environment(player)
//    }
//}

enum ResortSorting {
    case Default, Alphabetical, Country
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    @State private var searchText = ""
    @State private var favorites = Favorites()
    @State private var showingSort = false
    @State private var sorted: ResortSorting = .Default
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
           resorts
        } else {
            resorts.filter { $0.name.localizedStandardContains(searchText) }
        }
        
    }
    
    var filteredAndSorted: [Resort] {
        switch sorted {
        case .Default:
            filteredResorts
        case .Alphabetical:
            filteredResorts.sorted(by: { $0.name < $1.name })
        case .Country:
            filteredResorts.sorted(by: { $0.country < $1.country })
        }
    }

    
    var body: some View {
        NavigationSplitView {
            List(filteredAndSorted) { resort in
                NavigationLink(value: resort) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(
                                .rect(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )

                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundStyle(.secondary)
                                .actionSheet(isPresented: self.$showingSort) {
                                    ActionSheet(title: Text("Sort by:"), buttons: [
                                        .default(Text("Default")) {
                                            self.sorted = .Default
                                        },
                                        .default(Text("Alphabetical")) {
                                            self.sorted = .Alphabetical
                                        },
                                        .default(Text("Country")) {
                                            self.sorted = .Country
                                        },
                                        .cancel()
                                    ])
                                }
                        }
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                            .accessibilityLabel("This is a favorite resort")
                                .foregroundStyle(.red)
                        }
                    }
                    
                }
            }
            .navigationTitle("Resorts")
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort)
            }
            .searchable(text: $searchText, prompt: "Search for a resort")
            .navigationBarItems(
                    leading:
                        Button(action: {
                            self.showingSort.toggle()
                        }) {
                            Image(systemName: "arrow.up.arrow.down.circle")
                                .padding(5)
                                .background(Color.clear)
                                .clipShape(Circle())
                        })
            
            
        } detail: {
            WelcomeView()
        }
        .environment(favorites)
    }
   
    
}

#Preview {
    ContentView()
}
