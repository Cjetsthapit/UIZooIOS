    import SwiftUI
    import Combine
     
    // MARK: - ZooAnimal Class
     
    // Define a class representing an animal in the zoo
    class ZooAnimal {
        var name: String
        var isSleeping: Bool
        
        init(name: String, isSleeping: Bool) {
            self.name = name
            self.isSleeping = isSleeping
        }
    }
     
    // MARK: - Zoo Class
     
    // Define an observable object representing the zoo
    class Zoo: ObservableObject {
        // Published properties for racoon and parrot
        @Published var racoon: ZooAnimal
        @Published var parrot: ZooAnimal
        // Published property to track whether it's daytime or nighttime
        @Published var isDaytime: Bool
        
        init() {
            // Initialize racoon and parrot with default values
            self.racoon = ZooAnimal(name: "Racoon", isSleeping: true)
            self.parrot = ZooAnimal(name: "Parrot", isSleeping: false)
            // Initialize isDaytime as true (daytime)
            self.isDaytime = true
            
            // Use a timer publisher to toggle between day and night every 10 seconds
            Timer.publish(every: 10, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    self.toggleDaytime()
                }
                .store(in: &cancellables)
        }
        
        private var cancellables: Set<AnyCancellable> = []
        
        // Function to toggle between day and night, and update animal sleeping states accordingly
        func toggleDaytime() {
            withAnimation {
                isDaytime.toggle()
                racoon.isSleeping = !isDaytime
                parrot.isSleeping = isDaytime
            }
        }
    }
     
    // MARK: - ZooView Struct
     
    // Define the main view for the zoo
    struct ZooView: View {
        // ObservedObject property to observe changes in the Zoo class
        @ObservedObject var zoo: Zoo
        
        var body: some View {
            // Vertical stack containing the sun/moon image and details of racoon and parrot
            VStack {
                Image(systemName: zoo.isDaytime ? "sun.max.fill" : "moon.fill")
                    .font(.system(size: 50))
                    .padding()
                
                AnimalDetailView(animal: zoo.racoon)
                AnimalDetailView(animal: zoo.parrot)
            }
            // Set the background color based on daytime/nighttime
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(zoo.isDaytime ? Color.white : Color.black)
            // Set text color based on daytime/nighttime
            .foregroundColor(zoo.isDaytime ? Color.black : Color.white)
        }
    }
     
    // MARK: - AnimalDetailView Struct
     
    // Define a view for displaying animal details
    struct AnimalDetailView: View {
        // Property representing a zoo animal
        var animal: ZooAnimal
        
        var body: some View {
            // Vertical stack containing animal name and sleeping status
            VStack {
                Text(animal.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Text(animal.isSleeping ? "Sleeping" : "Awake")
                    .font(.subheadline)
                    .padding()
            }
            // Set background color based on sleeping status
            .background(animal.isSleeping ? Color.gray : Color.green)
            .cornerRadius(10)
            .padding()
        }
    }
     
    // MARK: - ContentView Struct
     
    // Main ContentView
    struct ContentView: View {
        var body: some View {
            // Initialize and display the ZooView
            ZooView(zoo: Zoo())
        }
    }
     
    // MARK: - ContentView Previews
     
    // PreviewProvider for ContentView
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            // Preview ContentView, set preferred color scheme to dark for dark mode preview
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
