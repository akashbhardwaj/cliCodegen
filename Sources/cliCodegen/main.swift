import ArgumentParser
import Foundation
struct CodeGen: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "A swift tool to generate design tokens in swift", subcommands: [Generate.self])
    
    init() { }
}
CodeGen.main()
struct Generate: ParsableCommand {

    static let configuration = CommandConfiguration(abstract: "Generate swift files")
    @Argument(help: "The name of the file")
    private var fileName: String
    
    @Flag(name: .long, help: "Verbose is for printing internal commands")
    private var verbose: Bool
    
    func run() throws {
            log("Versbose is enabled")
            log("Entered file path: \(fileName)")
            guard let fileUrl = URL(string: fileName) else {
                throw NSError(domain: "Not valid filepath", code: 500, userInfo: nil)
            }
            try parseJsonFile(atURL: fileUrl)
    }
    
    func log(_ item: Any) {
        if verbose {
            print(item)
        }
    }
}
extension Generate {
    func parseJsonFile(atURL url: URL) throws {
        let fileManager = FileManager.default
        log(fileManager.currentDirectoryPath)
        guard fileManager.fileExists(atPath: url.absoluteString) else {
            log("File not found \(url.absoluteString)")
            throw NSError(domain: "File not found", code: 500, userInfo: nil)
        }
        do {
            guard let jsonData = fileManager.contents(atPath: url.absoluteString) else {
                throw NSError(domain: "Not as file", code: 500, userInfo: nil)
            }
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed) as! [String: Any]
            try searchForGlobalTokens(json: json)
        } catch {
            log("\(error.localizedDescription)")
        }
    }
    
    func searchForGlobalTokens(json: [String: Any]) throws {
        log("Searching for Global tokens")
        guard let globalTokens = json["global_tokens"] as? [String: Any] else {
            throw NSError(domain: "Key 'global_tokens' not found", code: 404, userInfo: nil)
        }
        guard let colorTokenFilePath = try makeGlobalTokenDirectory(withFolderName: FolderNames.color, fileName: FileName.color) else {
            log("Error in creating folder and files")
            return
        }
        try findColorTokens(globalTokens: globalTokens, andWriteFileTo: colorTokenFilePath)
        
        
    }
    func findColorTokens(globalTokens: [String: Any], andWriteFileTo filePath: URL) throws {
        log("Finding Color Tokens and creating color file")
        guard let colors = globalTokens["colors"] as? [String: Any] else {
            return
        }
        var textToWrite = GlobalTokenConstants.Color.hexToColorExtension
        textToWrite += "\n\n"
        textToWrite += GlobalTokenConstants.Color.uiColorExtension
        let mappingFromValueToToken = colors.flatMap{"""
            static let \($0.key) = UIColor(hex: "\($0.value)")\n
            """}
        textToWrite += mappingFromValueToToken
        textToWrite += GlobalTokenConstants.Color.endCurlyBracket
        guard let data = textToWrite.data(using: .utf8) else {
            log("Erroe in converting from string to data")
            return
        }
        log("Trying to write: \(textToWrite)")
        try writeData(data: data, toFileURL: filePath)
    }
    
    func writeData(data: Data, toFileURL url: URL) throws {
        log("Writing to file: \(url.path)")
        do{
            let fileHandle = try FileHandle(forWritingTo: url as URL)
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
        } catch {
            log("\(error.localizedDescription)")
            throw error
        }
    }
    func makeGlobalTokenDirectory(withFolderName folderName: String, fileName: String) throws -> URL?{
        let fileManager = FileManager.default
        let folderPath = NSURL(fileURLWithPath: fileManager.currentDirectoryPath).appendingPathComponent(folderName)
        log("folderPath: \(folderPath?.absoluteString ?? "")")
        let filePath = folderPath!.appendingPathComponent(fileName)
        guard !fileManager.fileExists(atPath: filePath.path) else {
            return filePath
        }
        do {
            try fileManager.createDirectory(atPath: folderPath!.path, withIntermediateDirectories: true)
            let data = Data()
            try data.write(to: filePath)
            return filePath
        } catch{
            log(error.localizedDescription)
            throw error
        }
    }
}

