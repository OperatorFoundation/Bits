//
//  SimpleBits+MaybeIntable.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/27/20.
//

import Foundation
import Datable

extension SimpleBits: MaybeNetworkIntable
{
    public init?(maybeNetworkInt: Int) {
        if maybeNetworkInt < 0 || maybeNetworkInt > UINT8_MAX
        {
            return nil
        }
        
        let ui8 = UInt8(maybeNetworkInt)
        self.init(data: Data(array: [ui8]))
    }
    
    public var maybeNetworkInt: Int? {
        guard let int8 = self.maybeNetworkInt8 else
        {
            return nil
        }
        
        return Int(int8)
    }
    
    public init?(maybeNetworkInt8: Int8) {
        if maybeNetworkInt8 < 0 || maybeNetworkInt8 > UINT8_MAX
        {
            return nil
        }

        let ui8 = UInt8(maybeNetworkInt8)
        self.init(data: Data(array: [ui8]))
    }
    
    public var maybeNetworkInt8: Int8? {
        // Negative number
        if count == 8 && get(index: 0) == 1
        {
            guard let uint8 = self.maybeNetworkUint8 else
            {
                return nil
            }
            
            let dropSign = (uint8 << 1) >> 1
            let int8 = Int8(dropSign)
            return -int8
        }
        else // Non-negative number
        {
            guard let uint8 = self.maybeNetworkUint8 else
            {
                return nil
            }
            
            return Int8(uint8)
        }
    }
    
    public init?(maybeNetworkInt16: Int16) {
        if maybeNetworkInt16 < 0 || maybeNetworkInt16 > UINT8_MAX
        {
            return nil
        }

        let ui8 = UInt8(maybeNetworkInt16)
        self.init(data: Data(array: [ui8]))
    }
    
    public var maybeNetworkInt16: Int16? {
        guard let int8 = self.maybeNetworkInt8 else
        {
            return nil
        }
        
        return Int16(int8)
    }
    
    public init?(maybeNetworkInt32: Int32) {
        if maybeNetworkInt32 < 0 || maybeNetworkInt32 > UINT8_MAX
        {
            return nil
        }

        let ui8 = UInt8(maybeNetworkInt32)
        self.init(data: Data(array: [ui8]))
    }
    
    public var maybeNetworkInt32: Int32? {
        guard let int8 = self.maybeNetworkInt8 else
        {
            return nil
        }
        
        return Int32(int8)
    }
    
    public init?(maybeNetworkInt64: Int64) {
        if maybeNetworkInt64 < 0 || maybeNetworkInt64 > UINT8_MAX
        {
            return nil
        }

        let ui8 = UInt8(maybeNetworkInt64)
        self.init(data: Data(array: [ui8]))

    }
    
    public var maybeNetworkInt64: Int64? {
        guard let int8 = self.maybeNetworkInt8 else
        {
            return nil
        }
        
        return Int64(int8)
    }
    
    public init?(maybeNetworkUint: UInt) {
        if maybeNetworkUint < 0 || maybeNetworkUint > UINT8_MAX
        {
            return nil
        }

        let ui8 = UInt8(maybeNetworkUint)
        self.init(data: Data(array: [ui8]))
    }
    
    public var maybeNetworkUint: UInt? {
        guard let uint8 = self.maybeNetworkUint8 else
        {
            return nil
        }
        
        return UInt(uint8)
    }
    
    public init(maybeNetworkUint8: UInt8) {
        self.init(byte: maybeNetworkUint8)
    }
    
    public var maybeNetworkUint8: UInt8? // This can not actually fail.
    {
        let offset = UInt8.bitWidth - count
        return UInt8(buffer) >> offset
    }
    
    public init?(maybeNetworkUint16: UInt16) {
        if maybeNetworkUint16 < 0 || maybeNetworkUint16 > UINT8_MAX
        {
            return nil
        }

        let ui8 = UInt8(maybeNetworkUint16)
        self.init(data: Data(array: [ui8]))
    }
    
    public var maybeNetworkUint16: UInt16? // This can not actually fail.
    {
        return UInt16(self.maybeNetworkUint8!) // This can not actually fail.
    }
    
    public init?(maybeNetworkUint32: UInt32) {
        if maybeNetworkUint32 < 0 || maybeNetworkUint32 > UINT8_MAX
        {
            return nil
        }

        let ui8 = UInt8(maybeNetworkUint32)
        self.init(byte: ui8)
    }
    
    public var maybeNetworkUint32: UInt32? // This can not actually fail.
    {
        return UInt32(self.maybeNetworkUint8!) // This can not actually fail.
    }
    
    public init?(maybeNetworkUint64: UInt64) {
        if maybeNetworkUint64 < 0 || maybeNetworkUint64 > UINT8_MAX
        {
            return nil
        }

        let ui8 = UInt8(maybeNetworkUint64)
        self.init(byte: ui8)
    }
    
    public var maybeNetworkUint64: UInt64? // This can not actually fail.
    {
        return UInt64(self.maybeNetworkUint8!) // This can not actually fail.
    }
}
