import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var newDate = Date.now
    @State private var selectedItem: Item?

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink(destination: datePickerView(for: item)) {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func datePickerView(for item: Item) -> some View {
        VStack {
            DatePicker("Select a date", selection: $newDate)
                .padding(.horizontal)
                .onChange(of: newDate, initial: false) { _,newValue in
                    updateItem(item, with: newValue)
                }
                .onAppear {
                    selectedItem = item
                    newDate = item.timestamp
                }
        }
    }

    private func updateItem(_ item: Item, with newDate: Date) {
        withAnimation {
            item.timestamp = newDate
            do {
                try modelContext.save()
            } catch {
                print("Failed to save the updated date: \(error)")
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
