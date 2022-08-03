//
//  Environments.swift
//  Express
//
//  Created by Dr. Brandon Wiley on 7/24/22.
//

import Foundation

import Gardener

public class Environments
{
    static let applicationSupportDirectory = File.applicationSupportDirectory()
    static let environmentsDirectory = applicationSupportDirectory.appendingPathComponent("Environments")
    static let backupDirectory = environmentsDirectory.appendingPathComponent("Backup")
    
    public var activeEnvironment: URL = backupDirectory
    public var organisms: [Organism]
    
    public init(activeEnvironmentPath: URL?) {
        let _ = File.makeDirectory(url: Environments.environmentsDirectory)
        guard Environments.environmentsDirectory.hasDirectoryPath else {
            return
        }
        
        guard let contents = File.contentsOfDirectory(atPath: Environments.environmentsDirectory.path) else {
            return
        }
        
        if !Environments.backupDirectory.hasDirectoryPath {
            guard File.makeDirectory(url: Environments.backupDirectory) else {
                return
            }
        }
        
        let contentsIndex = contents.enumerated()
        for (_, subDir) in contentsIndex {
            let environmentSubDirectory = Environments.environmentsDirectory.appendingPathComponent(subDir)
            if environmentSubDirectory.hasDirectoryPath {
                organisms.append(Organism(name: subDir, directory: environmentSubDirectory))
            }
        }
        
        if activeEnvironmentPath != nil {
            self.activeEnvironment = activeEnvironmentPath!
        }
    }
    
    func gitCheckout(gitUrl: String, environmentName: String) {
        let environmentNamePath = Environments.environmentsDirectory.appendingPathComponent(environmentName)
        if !environmentNamePath.hasDirectoryPath {
            File.makeDirectory(url: environmentNamePath)
        }
        File.cd(environmentNamePath.path)
        Git().clone(gitUrl)
        
    }
    
    func createEnvironmentDirectory(name: String) {
    }
    
    func environmentSwitch() {
        
    }
    
    public struct Organism {
        let name: String
        let directory: URL
    }
}
