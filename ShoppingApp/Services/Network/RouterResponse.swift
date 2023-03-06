//
//  RouterResponse.swift
//  

import Foundation

public typealias RouterSuccessResponse = (_ json: Any?) -> Void
public typealias RouterFailureResponse = (_ error: Error?) -> Void
