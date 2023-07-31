//
//  ContentView.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import SwiftUI
import CoreData

/// The main view of the app, displaying a list of items and allowing the user to add, edit, and delete items.
struct ContentView: View {
    
    // The managed object context for Core Data
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var environment: Environments
    
    // The fetched results of the items in Core Data, sorted by timestamp
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    // The text entered by the user in the text field
    @State var text: String = ""
    
    // The calculated height of the text field based on its contents
    @State private var calculatedHeight: CGFloat = 32
    
    // The minimum and maximum height of the text field
    let minHeight: CGFloat = 32
    let maxHeight: CGFloat = 200
    
    
    
    /// The body of the view
    var body: some View {
        NavigationView {
            VStack{
                // The list of items
                List {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        NavigationLink {
                            // The detail view for the item
                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                .accessibilityIdentifier("PageText")
                            Button("Crash") {
                                fatalError("Crash was triggered")
                            }
                            
                        } label: {
                            Text(item.timestamp!, formatter: itemFormatter)
                        }
                        .accessibilityIdentifier("item\(index+1)")
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        // The button to add a new item
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                        .accessibilityIdentifier("AddButton")
                    }
                }
                Text("Select an item")
                    .foregroundColor(.gray)
                
                Text(environment.vars?["API_ENDPOINT"] ?? "")
                   
                Link("Connect With Salesforce", destination: URL(string: "https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9ZUGg10Hh227MLPM3wiLMlm14912oDqdl4sBAgV3rUL880XmgYEXzKDYkuelHPJaxNtcjpXvY0bMjUSZZ&redirect_uri=salessparrow://oauth")!)
                
                DateTimePicker()
                
                ExpandableTextView(text: $text, highlightPattern: "swift")
            }
            .navigationTitle("Items")
            .onOpenURL { incomingURL in
                handleIncomingURL(incomingURL)
            }
        }
    }
    
    /// Handle incoming URLs from deep links with the custom URL scheme registered in the app's Info.plist
    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "SalesSparrow" else {
            return
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return
        }
        print("components \(components)")
    }
    
    /// Adds a new item to Core Data
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    /// Deletes the selected items from Core Data
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

/// The formatter for displaying the timestamp of an item
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
