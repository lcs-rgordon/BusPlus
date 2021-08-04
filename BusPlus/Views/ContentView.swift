//
//  ContentView.swift
//  BusPlus
//
//  Created by Russell Gordon on 2021-08-03.
//

import SwiftUI

struct ContentView: View {
    
    @State private var buses = [Bus]()
    @State private var search = ""
    @State private var favouriteBuses = [Bus]()
    
    enum Field {
        case firstName
        case lastName
        case amount
    }
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var amount = ""
    
    @FocusState private var focusedField: Field?
    
    var filteredBuses: [Bus] {
        if search.isEmpty {
            return buses
        } else {
            return buses.filter({ bus in
                bus.name.localizedCaseInsensitiveContains(search) ||
                bus.location.localizedCaseInsensitiveContains(search) ||
                bus.destination.localizedCaseInsensitiveContains(search)
            })
        }
    }
    
    var body: some View {
        TabView {
            NavigationView {
                
                List(filteredBuses) { bus in
                    
                    ZStack {
                        
                        // See: https://swiftwithmajid.com/2021/07/07/mastering-asyncimage-in-swiftui/
                        AsyncImage(url: URL(string: bus.image)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .padding(0)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 300, height: 200)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(0)
                        
                        VStack {
                            Spacer()
                            VStack {
                                HStack {
                                    Spacer(minLength: 50)
                                    Text(bus.name)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 5)
                                    Spacer(minLength: 50)
                                }
                                HStack {
                                    Spacer(minLength: 50)
                                    Text("At **\(bus.location)**\ngoing to **\(bus.destination)**")
                                        .font(.subheadline)
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom, 5)
                                    Spacer(minLength: 50)
                                }
                            }
                            .background(Color.primary.colorInvert().opacity(0.8))
                        }
                        VStack {
                            
                            HStack {
                                
                                Spacer()
                                
                                Text("\(Image(systemName: "person.3.fill").symbolRenderingMode(.hierarchical)) \(bus.passengers)")
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .padding(30)
                                    .background(Color.primary.colorInvert().opacity(0.8))
                                    .clipShape(Circle())
                                    .offset(x: 5, y: -15)
                            }
                            
                            Spacer()
                        }
                        
                        
                        
                        
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        if favouriteBuses.contains(where: { currentBus in
                            currentBus == bus
                        }) {
                            Button {
                                let index = favouriteBuses.firstIndex(of: bus)!
                                favouriteBuses.remove(at: index)
                                print(favouriteBuses)
                            } label: {
                                Label("Remove from favourites", systemImage: "heart")
                            }
                            .tint(.gray)
                        } else {
                            Button {
                                favouriteBuses.append(bus)
                                print(favouriteBuses)
                            } label: {
                                Label("Add to favourites", systemImage: "heart.fill")
                            }
                            .tint(.pink)
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                }
                .searchable(text: $search.animation(), prompt: "Name, location, or destination")
                .listStyle(PlainListStyle())
                .navigationTitle("Buses")
                .task {
                    await refreshBuses()
                }
                .refreshable {
                    print("refreshing")
                    await refreshBuses()
                }
                
            }
            .tabItem {
                Image(systemName: "bus")
                Text("Buses")
            }
            
            NavigationView {
                
                
                List(favouriteBuses) { bus in
                    
                    ZStack {
                        
                        // See: https://swiftwithmajid.com/2021/07/07/mastering-asyncimage-in-swiftui/
                        AsyncImage(url: URL(string: bus.image)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .padding(0)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 300, height: 200)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(0)
                        
                        VStack {
                            Spacer()
                            VStack {
                                HStack {
                                    Spacer(minLength: 50)
                                    Text(bus.name)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 5)
                                    Spacer(minLength: 50)
                                }
                                HStack {
                                    Spacer(minLength: 50)
                                    Text("From: \(Text("**\(bus.location)**").foregroundColor(Color.blue))")
                                    Text("At \(Text("**\(bus.location)**").foregroundColor(Color.blue))\ngoing to \(Text("**\(bus.destination)**").foregroundColor(Color.purple))")
                                    //                                    Text("At **\(bus.location)**\ngoing to **\(bus.destination)**")
                                        .font(.subheadline)
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom, 5)
                                    Spacer(minLength: 50)
                                }
                            }
                            .background(Color.primary.colorInvert().opacity(0.8))
                        }
                        VStack {
                            
                            HStack {
                                
                                Spacer()
                                
                                Text("\(Image(systemName: "person.3.fill")) \(bus.passengers)")
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .padding(30)
                                    .background(Color.primary.colorInvert().opacity(0.8))
                                    .clipShape(Circle())
                                    .offset(x: 5, y: -15)
                            }
                            
                            Spacer()
                        }
                        
                        
                        
                        
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            let index = favouriteBuses.firstIndex(of: bus)!
                            favouriteBuses.remove(at: index)
                            print(favouriteBuses)
                        } label: {
                            Label("Remove from favourites", systemImage: "heart")
                        }
                        .tint(.gray)
                    }
                    .listRowSeparator(.hidden)
                    
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Favourites")
                
                
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favourites")
            }
            
            NavigationView {
                VStack {
                    
                    TextField("First name", text: $firstName)
                        .focused($focusedField, equals: .firstName)
                        .textContentType(.givenName)
                        .submitLabel(.next)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    
                    
                    TextField("Last name", text: $lastName)
                        .focused($focusedField, equals: .lastName)
                        .textContentType(.familyName)
                        .submitLabel(.next)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .amount)
                        .submitLabel(.done)
                        .padding(.horizontal)
                        .padding(.vertical, 10)

                    Spacer()
                    
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        
                        Spacer()
                        
                        Button("Done") {
                            // Dismiss the keyboard
                            focusedField = nil
                        }
                        .disabled(focusedField == .amount ? false : true)
                    }
                }
                .onSubmit {
                    switch focusedField {
                    case .firstName:
                        focusedField = .lastName    // Transfer focus to the last name field
                    case .lastName:
                        focusedField = .amount    // Transfer focus to the last name field
                    default:
                        focusedField = nil  // All done, so go to no field next, and hide the keyboard
                    }
                }
                .task {
                    print("hello")
                    focusedField = .firstName
                }
                // Dismiss the keyboard when something else is tapped
                .onTapGesture {
                    focusedField = nil
                }
                .navigationTitle("Tickets")
                
            }
            .tabItem {
                Image(systemName: "ticket.fill")
                Text("Tickets")
            }
        }
        
    }
    
    func refreshBuses() async {
        do {
            let newBuses = try await fetchBuses()
            
            withAnimation {
                buses = newBuses
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchBuses() async throws -> [Bus] {
        let busURL = URL(string: "https://www.hackingwithswift.com/samples/bus-timetable")!
        // Use the extension defined earlier
        return try await URLSession.shared.decode(from: busURL)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
