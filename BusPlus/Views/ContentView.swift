//
//  ContentView.swift
//  BusPlus
//
//  Created by Russell Gordon on 2021-08-03.
//

import SwiftUI

struct ContentView: View {
    
    @State private var buses = [Bus]()
    
    var body: some View {
        
        NavigationView {
            
            List(buses) { bus in
                
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
                                Text(bus.location)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 5)
                                Spacer(minLength: 50)
                            }
                        }
                        .background(Color.primary.colorInvert().opacity(0.8))
                    }
                    
                }
                .listRowSeparator(.hidden)
                
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Buses")
            .task {
                do {
                    buses = try await fetchBuses()
                } catch {
                    print(error.localizedDescription)
                }
            }
            
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
