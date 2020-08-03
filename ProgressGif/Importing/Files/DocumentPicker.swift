//
//  DocumentPicker.swift
//  ProgressGif
//
//  Created by Zheng on 7/31/20.
//

import UIKit
import MobileCoreServices

public enum SourceType: Int {
    case files
    case folder
}
protocol DocumentDelegate: class {
//    func didPickDocuments(documents: [Document]?)
    func didPickDocument(document: Document?)
}

class Document: UIDocument {
    var data: Data?
    override func contents(forType typeName: String) throws -> Any {
        guard let data = data else { return Data() }
        return try NSKeyedArchiver.archivedData(withRootObject:data,
                                                requiringSecureCoding: true)
    }
    override func load(fromContents contents: Any, ofType typeName:
        String?) throws {
        guard let data = contents as? Data else { return }
        self.data = data
    }
}

open class DocumentPicker: NSObject {
    private var pickerController: UIDocumentPickerViewController?
    private weak var presentationController: UIViewController?
    private weak var delegate: DocumentDelegate?

    private var folderURL: URL?
//    private var sourceType: SourceType!
//    private var documents = [Document]()
    private var pickedDocument: Document?

    init(presentationController: UIViewController, delegate: DocumentDelegate) {
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate

    }

//    public func fileAction(for type: SourceType, title: String) -> UIAlertAction? {
//        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
//            self.pickerController = UIDocumentPickerViewController(documentTypes: [kUTTypeMovie as String, kUTTypeImage as String], in: .open)
//            self.pickerController!.delegate = self
//            self.pickerController!.allowsMultipleSelection = true
//            self.presentationController?.present(self.pickerController!, animated: true)
//        }
//    }

    public func displayPicker() {
        self.pickerController = UIDocumentPickerViewController(documentTypes: [kUTTypeMovie as String, kUTTypeImage as String], in: .import)
        self.pickerController!.delegate = self
        self.presentationController?.present(self.pickerController!, animated: true)
    }

}

extension DocumentPicker: UIDocumentPickerDelegate{

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        guard let url = urls.first else {
            return
        }
        documentFromURL(pickedURL: url)
//        delegate?.didPickDocuments(documents: documents)
        delegate?.didPickDocument(document: pickedDocument)
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//        delegate?.didPickDocuments(documents: nil)

        delegate?.didPickDocument(document: nil)
    }

    private func documentFromURL(pickedURL: URL) {
        let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()

        defer {
            if shouldStopAccessing {
                pickedURL.stopAccessingSecurityScopedResource()
            }
        }

        NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (folderURL) in

            let document = Document(fileURL: pickedURL)
//            documents.append(document)
            pickedDocument = document

//            print("documents: \(documents)")
        }
    }

}
