//
//  LogHandler.swift
//
//  Esse código-fonte é adaptado de Swift Logging API open source project (https://github.com/apple/swift-log)
//
//  Adapted by Heitor Novais on 10/03/23.
//

import Foundation

public protocol LogHandler {
    
    /// Este método é chamado quando um `LogHandler` deve emitir uma mensagem de log. Não há necessidade de o `LogHandler`
    /// verifica se o `level` está acima ou abaixo do `logLevel` configurado pois o `Logger` já realizou esta verificação e
    /// determinou que uma mensagem deve ser registrada.
    ///
    /// - parameters:
    /// - level: O nível de log em que a mensagem foi registrada.
    /// - message: A mensagem a ser registrada. Para obter uma representação `String` chame `message.description`.
    /// - metadata: Os metadados associados a esta mensagem de log.
    /// - source: A fonte de origem da mensagem de log, por exemplo, o módulo de log.
    /// - file: O arquivo do qual a mensagem de log foi emitida.
    /// - function: A função da qual a linha de log foi emitida.
    /// - line: A linha da qual a mensagem de log foi emitida.
    func log(level: Logger.Level,
             message: Logger.Message,
             metadata: Logger.Metadata?,
             source: String,
             file: String,
             function: String,
             line: UInt)
    
    /// Adicione, remova ou altere os metadados de registro.
    ///
    /// - note: `LogHandler`s devem tratar os metadados de registro como um tipo de valor. Isso significa que a alteração nos metadados deve
    /// afeta apenas este `LogHandler`.
    ///
    /// - parameters:
    /// - metadataKey: A chave para o item de metadados
    subscript(metadataKey _: String) -> Logger.Metadata.Value? { get set }
    
    /// Obtenha ou defina todo o armazenamento de metadados como um dicionário.
    ///
    /// - note: `LogHandler`s devem tratar os metadados de registro como um tipo de valor. Isso significa que a alteração nos metadados deve
    /// afeta apenas este `LogHandler`.
    var metadata: Logger.Metadata? { get set }
    
    /// Obtenha ou defina o nível de log configurado.
    ///
    /// - note: `LogHandler`s devem tratar o nível de log como um tipo de valor. Isso significa que a alteração nos metadados deve
    /// afeta apenas este `LogHandler`. É aceitável fornecer alguma forma de substituição de nível de log global
    /// isso significa que uma alteração no nível de log em um `LogHandler` específico pode não ser refletida em nenhum
    /// `LogHandler`.
    var logLevel: Logger.Level { get set }
}
