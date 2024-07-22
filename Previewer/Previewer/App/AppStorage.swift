import Combine

class AppStorage: ObservableObject {

    @Published var invalidPictures: Set<Picture> = []

    func addPicture(_ picture: Picture) {
        invalidPictures.insert(picture)
    }

    func removePicture(_ picture: Picture) {
        invalidPictures.remove(picture)
    }

    func isValidPicture(_ picture: Picture) -> Bool {
        !invalidPictures.contains(picture)
    }
}
