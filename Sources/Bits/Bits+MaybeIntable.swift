//
//  Bits+MaybeIntable.swift
//  
//
//  Created by Dr. Brandon Wiley on 4/1/20.
//

import Foundation
import Datable

extension Bits: MaybeNetworkIntable
{
    func rightAlign(bitsNeeded: Int) -> Data?
    {
        guard bitsNeeded >= count else {return nil}
        guard bitsNeeded % 8 == 0 else {return nil}
        let bytesNeeded = bitsNeeded / 8
        
        guard let extra = leftover else {return nil}
        guard buffer.count > 0 && extra.count > 0 else {return nil}
        
        let neededForAlignment = 8 - (count % 8)
        
        var aligned = Bits()
        
        for _ in 0..<neededForAlignment
        {
            guard aligned.pack(bit: 0) else {return nil}
        }
        
        guard aligned.pack(bits: self) else {return nil}
        
        guard aligned.byteAligned else {return nil}
        
        let alignedData = aligned.data
        
        if alignedData.count == bytesNeeded
        {
            return alignedData
        }
        else
        {
            let bytesStillNeeded = bytesNeeded - alignedData.count
            let padding = Data(repeating: 0, count: bytesStillNeeded)
            var result = Data()
            result.append(padding)
            result.append(alignedData)
            return result
        }
    }

    var negative: Bool
    {
        get
        {
            if byteAligned
            {
                let prefix=buffer[0..<1]
                guard let simple = SimpleBits(data: prefix) else {return false}
                return simple.get(index: 0) == 1
            }
            else
            {
                return false
            }
        }
    }
    
    var cleared: Bits?
    {
        let prefix = buffer[0..<1]
        let rest = buffer[1...]
        guard var simple = SimpleBits(data: prefix) else {return nil}
                
        // Clear sign bit
        guard simple.set(bit: 0, index: 0) else {return nil}
        let cleared = simple.data
        
        var result = Data()
        result.append(cleared)
        result.append(rest)

        return Bits(data: result)
    }
    
    public init?(maybeNetworkInt: Int) {
        self.init(data: maybeNetworkInt.data)
    }
    
    public var maybeNetworkInt: Int? {
        if count > Int.bitWidth
        {
            return nil
        }
        
        if negative
        {
            guard let c = cleared else {return nil}
            guard let uintNoSign = c.maybeNetworkUint else {return nil}
            let int = Int(uintNoSign)
            return -int
        }
        else
        {
            guard let uint = self.maybeNetworkUint else {return nil}
            return Int(uint)
        }
    }
    
    public init?(maybeNetworkInt8: Int8) {
        self.init(data: maybeNetworkInt8.data)
    }
    
    public var maybeNetworkInt8: Int8? {
        if count > Int8.bitWidth
        {
            return nil
        }
        
        if negative
        {
            guard let c = cleared else {return nil}
            guard let uint8NoSign = c.maybeNetworkUint8 else {return nil}
            let int8 = Int8(uint8NoSign)
            return -int8
        }
        else
        {
            guard let uint8 = self.maybeNetworkUint8 else {return nil}
            return Int8(uint8)
        }
    }
    
    public init?(maybeNetworkInt16: Int16) {
        self.init(data: maybeNetworkInt16.data)
    }
    
    public var maybeNetworkInt16: Int16? {
        if count > Int16.bitWidth
        {
            return nil
        }
        
        if negative
        {
            guard let c = cleared else {return nil}
            guard let uint16NoSign = c.maybeNetworkUint16 else {return nil}
            let int16 = Int16(uint16NoSign)
            return -int16
        }
        else
        {
            guard let uint16 = self.maybeNetworkUint16 else {return nil}
            return Int16(uint16)
        }
    }
    
    public init?(maybeNetworkInt32: Int32) {
        self.init(data: maybeNetworkInt32.data)
    }
    
    public var maybeNetworkInt32: Int32? {
        if count > Int32.bitWidth
        {
            return nil
        }
        
        if negative
        {
            guard let c = cleared else {return nil}
            guard let uint32NoSign = c.maybeNetworkUint32 else {return nil}
            let int32 = Int32(uint32NoSign)
            return -int32
        }
        else
        {
            guard let uint32 = self.maybeNetworkUint32 else {return nil}
            return Int32(uint32)
        }
    }
    
    public init?(maybeNetworkInt64: Int64) {
        self.init(data: maybeNetworkInt64.data)
    }
    
    public var maybeNetworkInt64: Int64? {
        if count > Int64.bitWidth
        {
            return nil
        }
        
        if negative
        {
            guard let c = cleared else {return nil}
            guard let uint64NoSign = c.maybeNetworkUint64 else {return nil}
            let int64 = Int64(uint64NoSign)
            return -int64
        }
        else
        {
            guard let uint64 = self.maybeNetworkUint64 else {return nil}
            return Int64(uint64)
        }
    }
    
    public init?(maybeNetworkUint: UInt) {
        self.init(data: maybeNetworkUint.data)
    }
    
    public var maybeNetworkUint: UInt? {
        if count > UInt.bitWidth
        {
            return nil
        }
                
        if byteAligned // Just bytes
        {
            if let u64 = maybeNetworkUint64
            {
                return UInt(u64)
            }
            else
            {
                return UInt(data: buffer)
            }
        }
        else if buffer.count == 0 // Just bits
        {
            guard let extra = leftover else {return nil}
            return extra.maybeNetworkUint
        }
        else // Both bytes and bits
        {
            guard let data = rightAlign(bitsNeeded: UInt.bitWidth) else {return nil}
            return UInt(data: data)
        }
    }
    
    public init?(maybeNetworkUint8: UInt8) {
        self.init(data: maybeNetworkUint8.data)
    }
    
    public var maybeNetworkUint8: UInt8? {
        if count == 0 || count > UInt8.bitWidth
        {
            return nil
        }
        
        if byteAligned // count <= UInt8.bitwidth && byteAligned implies exactly 8 bits
        {
            return UInt8(data: buffer)
        }
        else
        {
            guard let extra = leftover else {return nil}
            return extra.maybeNetworkUint8
        }
    }
    
    public init?(maybeNetworkUint16: UInt16) {
        self.init(data: maybeNetworkUint16.data)
    }
    
    public var maybeNetworkUint16: UInt16? {
        if count == 0 || count > UInt16.bitWidth
        {
            return nil
        }
        
        if byteAligned // Just bytes
        {
            // count <= UInt16.bitwidth && byteAligned implies 8 or 16 bits
            if let u8 = maybeNetworkUint8
            {
                return UInt16(u8)
            }
            else
            {
                return UInt16(data: buffer)
            }
        }
        else if buffer.count == 0 // Just bits
        {
            guard let extra = leftover else {return nil}
            return extra.maybeNetworkUint16
        }
        else // Both bytes and bits
        {
            guard let data = rightAlign(bitsNeeded: UInt16.bitWidth) else {return nil}
            return UInt16(data: data)
        }
    }
    
    public init?(maybeNetworkUint32: UInt32) {
        self.init(data: maybeNetworkUint32.data)
    }
    
    public var maybeNetworkUint32: UInt32? {
        if count == 0 || count > UInt32.bitWidth
        {
            return nil
        }
        
        if byteAligned // Just bytes
        {
            if let u16 = maybeNetworkUint16
            {
                return UInt32(u16)
            }
            else
            {
                return UInt32(data: buffer)
            }
        }
        else if buffer.count == 0 // Just bits
        {
            guard let extra = leftover else {return nil}
            return extra.maybeNetworkUint32
        }
        else // Both bytes and bits
        {
            guard let data = rightAlign(bitsNeeded: UInt32.bitWidth) else {return nil}
            return UInt32(data: data)
        }
    }
    
    public init?(maybeNetworkUint64: UInt64) {
        self.init(data: maybeNetworkUint64.data)
    }
    
    public var maybeNetworkUint64: UInt64? {
        if count == 0 || count > UInt64.bitWidth
        {
            return nil
        }
        
        if byteAligned // Just bytes
        {
            if let u32 = maybeNetworkUint32
            {
                return UInt64(u32)
            }
            else
            {
                return UInt64(data: buffer)
            }
        }
        else if buffer.count == 0 // Just bits
        {
            guard let extra = leftover else {return nil}
            return extra.maybeNetworkUint64
        }
        else // Both bytes and bits
        {
            guard let data = rightAlign(bitsNeeded: UInt64.bitWidth) else {return nil}
            return UInt64(data: data)
        }
    }
}
