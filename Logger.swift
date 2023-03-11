//
//  Logger.swift
//
//  Esse código-fonte é adaptado de Swift Logging API open source project (https://github.com/apple/swift-log)
//
//  Adapted by Heitor Novais on 10/03/23.
//

import Foundation

public class Logger {

    // MARK: Types

    /// `Metadata` é um typealias para `[String: Logger.MetadataValue]`,  o tipo de armazenamento de metadados.
    public typealias Metadata = [String: MetadataValue]

    public enum MetadataValue {

        /// Um valor de metadados que é uma `String`.
        case string(String)

        /// Um valor de metadados que é algum `CustomStringConvertible`.
        case stringConvertible(CustomStringConvertible)

        /// Um valor de metadados que é um dicionário de `String` a `Logger.MetadataValue`.
        case dictionary(Metadata)

        /// Um valor de metadados que é um array de `Logger.MetadataValue`s.
        case array([Metadata.Value])
    }

    public enum Level: String, Codable, CaseIterable {

        /// Apropriado para mensagens que contenham informações normalmente de uso somente quando
        /// rastreando a execução de um programa.
        case trace

        /// Apropriado para mensagens que contenham informações normalmente de uso somente quando
        /// depurando um programa.
        case debug

        /// Adequado para mensagens informativas.
        case info

        /// Apropriado para mensagens que não são condições de erro, mas que requerem observação
        case warning

        /// Apropriado para condições de erro.
        case error

        /// Adequado para condições críticas de erro que geralmente requerem atenção
        case critical

        /// Adequado para condições de erro que causam crash
        case fatal

        public func integerValue() -> Self.AllCases.Index {
            return Self.allCases.firstIndex(of: self)!
        }
    }

    /// `Logger.Message` representa o texto de uma mensagem de log. Geralmente é criado usando strings literais.
    ///
    /// Exemplo criando um `Logger.Message`:
    ///
    /// let  world: String = "world"
    /// let myLogMessage: Logger.Message = "Hello \(world)"
    ///
    /// Mais comumente, `Logger.Message`s aparecem simplesmente como o parâmetro para um método de log como:
    ///
    /// logger.info("Hello \(world)")
    ///
    public struct Message: ExpressibleByStringLiteral, Equatable, CustomStringConvertible, ExpressibleByStringInterpolation {

        public typealias StringLiteralType = String

        private var value: String

        public init(stringLiteral value: String) {
            self.value = value
        }

        public var description: String {
            return self.value
        }
    }

    // MARK: Private Properties

    private var handler: LogHandler

    // MARK: Public Properties

    public var logLevel: Logger.Level {
        get {
            return self.handler.logLevel
        }
        set {
            self.handler.logLevel = newValue
        }
    }

    // MARK: Initialization

    public init(handler: LogHandler) {
        self.handler = handler
    }

    // MARK: Methods

    /// Registra uma mensagem passando o nível de log como parâmetro.
    ///
    /// Se o ``logLevel`` passado para este método for mais severo que o ``logLevel`` do `Logger`, ele será logado,
    /// senão nada vai acontecer.
    ///
    /// - parameters:
    /// - level: O nível de log para registrar a `mensagem`. Para os níveis de log disponíveis, consulte `Logger.Level`.
    /// - message: A mensagem a ser registrada. `message` pode ser usado com qualquer literal de interpolação de string.
    /// - metadata: metadados únicos para anexar a esta mensagem de log.
    /// - file: O arquivo de origem desta mensagem de log (geralmente não há necessidade de passá-lo explicitamente, pois
    ///      o padrão é `#file`
    /// - function: A função da qual esta mensagem de log se origina (geralmente não há necessidade de passá-la explicitamente como
    ///         o padrão é `#function`).
    /// - linha: A linha da qual esta mensagem de log se origina (geralmente não há necessidade de passá-la explicitamente, pois
    ///       o padrão é `#line`).
    public func log(level: Logger.Level,
                    _ message: @autoclosure () -> Logger.Message,
                    metadata: @autoclosure () -> Logger.Metadata? = nil,
                    source: @autoclosure () -> String? = nil,
                    file: String = #file, function: String = #function, line: UInt = #line) {
        if self.logLevel <= level {
            self.handler.log(level: level,
                             message: message(),
                             metadata: metadata(),
                             source: source() ?? Logger.currentModule(filePath: (file)),
                             file: file,
                             function: function,
                             line: line)
        }
    }

    /// Adicionar, alterar ou remover um item de metadados de registro.
    ///
    /// - note: os metadados de registro se comportam como um valor que significa que uma alteração nos metadados de registro afetará apenas o
    ///
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.handler[metadataKey: metadataKey]
        }
        set {
            self.handler[metadataKey: metadataKey] = newValue
        }
    }
}

extension Logger {

    /// Registra uma mensagem passando com o nível de registro ``Logger/Level/trace``.
    ///
    /// Se `.trace` for pelo menos tão severo quanto ``logLevel`` do `Logger`, ele será logado,
    /// senão nada vai acontecer.
    public func trace(_ message: @autoclosure () -> Logger.Message,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: @autoclosure () -> String? = nil,
                      file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .trace, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }

    /// Registra uma mensagem passando com o nível de registro ``Logger/Level/debug``.
    ///
    /// Se `.debug` for pelo menos tão severo quanto ``logLevel`` do `Logger`, ele será logado,
    /// senão nada vai acontecer.
    public func debug(_ message: @autoclosure () -> Logger.Message,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: @autoclosure () -> String? = nil,
                      file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .debug, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }

    /// Registra uma mensagem passando com o nível de registro ``Logger/Level/info``.
    ///
    /// Se `.info` for pelo menos tão severo quanto ``logLevel`` do `Logger`, ele será logado,
    /// senão nada vai acontecer.
    public func info(_ message: @autoclosure () -> Logger.Message,
                     metadata: @autoclosure () -> Logger.Metadata? = nil,
                     source: @autoclosure () -> String? = nil,
                     file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .info, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }

    /// Registra uma mensagem passando com o nível de registro ``Logger/Level/warning``.
    ///
    /// Se `.warning` for pelo menos tão severo quanto ``logLevel`` do `Logger`, ele será logado,
    /// senão nada vai acontecer.
    public func warn(_ message: @autoclosure () -> Logger.Message,
                     metadata: @autoclosure () -> Logger.Metadata? = nil,
                     source: @autoclosure () -> String? = nil,
                     file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .warning, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }

    /// Registra uma mensagem passando com o nível de registro ``Logger/Level/error``.
    ///
    /// Se `.error` for pelo menos tão severo quanto ``logLevel`` do `Logger`, ele será logado,
    /// senão nada vai acontecer.
    public func error(_ message: @autoclosure () -> Logger.Message,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: @autoclosure () -> String? = nil,
                      file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .error, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }

    /// Registra uma mensagem passando com o nível de registro ``Logger/Level/critical``.
    ///
    /// Se `.critical` for pelo menos tão severo quanto ``logLevel`` do `Logger`, ele será logado,
    /// senão nada vai acontecer.
    public func critical(_ message: @autoclosure () -> Logger.Message,
                         metadata: @autoclosure () -> Logger.Metadata? = nil,
                         source: @autoclosure () -> String? = nil,
                         file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .critical, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }

    /// Registra uma mensagem passando com o nível de registro ``Logger/Level/fatal``.
    ///
    /// Se `.fatal` for pelo menos tão severo quanto ``logLevel`` do `Logger`, ele será logado,
    /// senão nada vai acontecer.
    public func fatal(_ message: @autoclosure () -> Logger.Message,
                      metadata: @autoclosure () -> Logger.Metadata? = nil,
                      source: @autoclosure () -> String? = nil,
                      file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .fatal, message(), metadata: metadata(), source: source(), file: file, function: function, line: line)
    }
}

extension Logger {

    private static func currentModule(filePath: String = #file) -> String {
        let utf8All = filePath.utf8
        return filePath.utf8.lastIndex(of: UInt8(ascii: "/")).flatMap { lastSlash -> Substring? in
            utf8All[..<lastSlash].lastIndex(of: UInt8(ascii: "/")).map { secondLastSlash -> Substring in
                filePath[utf8All.index(after: secondLastSlash) ..< lastSlash]
            }
        }.map {
            String($0)
        } ?? "n/a"
    }
}

extension Logger.MetadataValue: Equatable {
    
    public static func == (lhs: Logger.Metadata.Value, rhs: Logger.Metadata.Value) -> Bool {
        switch (lhs, rhs) {
        case (.string(let lhs), .string(let rhs)):
            return lhs == rhs
        case (.array(let lhs), .array(let rhs)):
            return lhs == rhs
        case (.dictionary(let lhs), .dictionary(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}

extension Logger.MetadataValue: ExpressibleByStringLiteral {

    public typealias StringLiteralType = String

    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension Logger.MetadataValue: CustomStringConvertible {

    public var description: String {
        switch self {
        case .dictionary(let dict):
            return dict.mapValues { $0.description }.description
        case .array(let list):
            return list.map { $0.description }.description
        case .string(let str):
            return str
        case .stringConvertible(let repr):
            return repr.description
        }
    }
}

extension Logger.MetadataValue: ExpressibleByDictionaryLiteral {

    public typealias Key = String
    public typealias Value = Logger.Metadata.Value

    public init(dictionaryLiteral elements: (String, Logger.Metadata.Value)...) {
        self = .dictionary(.init(uniqueKeysWithValues: elements))
    }
}

extension Logger.MetadataValue: ExpressibleByArrayLiteral {

    public typealias ArrayLiteralElement = Logger.Metadata.Value

    public init(arrayLiteral elements: Logger.Metadata.Value...) {
        self = .array(elements)
    }
}

extension Logger.MetadataValue: ExpressibleByStringInterpolation {}

extension Logger.Level: Comparable {

    public static func < (lhs: Logger.Level, rhs: Logger.Level) -> Bool {
        return lhs.integerValue() < rhs.integerValue()
    }
}

extension Logger.Level: Comparable {

    public static func < (lhs: Logger.Level, rhs: Logger.Level) -> Bool {
        return lhs.integerValue() < rhs.integerValue()
    }
}
