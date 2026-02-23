//
//  ObjectValueProtocol.swift
//  Processes
//
//  Created by DE4ME on 22.02.2026.
//


protocol ObjectValueProtocol {
    func objectValue(for column: SortColumnName, at row: Int) -> Any?;
}