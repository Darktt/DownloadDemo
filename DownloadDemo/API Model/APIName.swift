//
//  APIName.swift
//
//  Created by Darktt on 2025/8/12.
//  Copyright © 2025 Darktt. All rights reserved.
//

import Foundation

@MainActor
public
struct APIName
{
    // MARK: - Properties -
    
    public
    var url: URL
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    private
    init(_ urlString: String)
    {
        self.url = URL(string: urlString)!
    }
}

public
extension APIName
{
    static
    var download100MB: APIName {
        
        APIName("https://proof.ovh.net/files/100Mb.dat")
    }
    
    static
    var download1GB: APIName {
        
        APIName("https://proof.ovh.net/files/1Gb.dat")
    }
    
    static
    var download10GB: APIName {
        
        APIName("https://proof.ovh.net/files/10Gb.dat")
    }
}
