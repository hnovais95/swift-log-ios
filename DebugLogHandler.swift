//
//  DebugLogHandler.swift
//
//  Created by Heitor Novais on 10/03/23.
//

import Foundation

public class DebugLogHandler: LogHandler {
    
    // MARK: Properties
    
    public var logLevel: Logger.Level = .info
    
    private var prettyMetadata: String?
    public var metadata: Logger.Metadata? {
        didSet {
            guard let metadata = metadata else {
                prettyMetadata = nil
                return
            }
            self.prettyMetadata = self.prettify(metadata)
        }
    }
    
    // MARK: Inicialization
    
    public init(logLevel: Logger.Level = .info, metadata: Logger.Metadata? = nil) {
        self.logLevel = logLevel
        self.metadata = metadata
        
        if let metadata = metadata {
            self.prettyMetadata = self.prettify(metadata)
        }
    }
    
    // MARK: Methods
    
    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata explicitMetadata: Logger.Metadata?,
                    source: String,
                    file: String,
                    function: String,
                    line: UInt) {
        let prettyMetadata: String?
        if let explicitMetadata = explicitMetadata {
            prettyMetadata = self.prettify(explicitMetadata)
        } else {
            prettyMetadata = self.prettyMetadata
        }
        print("\(Date().description) \(level) :\(prettyMetadata.map { " \($0)" } ?? "") [\(source)] [\(file)] [\(function): \(line)] \(message)\n")
    }
    
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata?[metadataKey]
        }
        set {
            if self.metadata == nil, let newValue = newValue {
                metadata = [metadataKey: newValue]
            } else {
                self.metadata?[metadataKey] = newValue
            }
        }
    }
    
    private func prettify(_ metadata: Logger.Metadata) -> String? {
        if metadata.isEmpty {
            return nil
        } else {
            return metadata.lazy.sorted(by: { $0.key < $1.key }).map { "\($0)=\($1)" }.joined(separator: " ")
        }
    }
}
