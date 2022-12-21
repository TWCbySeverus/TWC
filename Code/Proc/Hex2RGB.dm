proc
    GetRedPart(hex)
        hex = uppertext(hex)
        var
            hi = text2ascii(hex, 2)
            lo = text2ascii(hex, 3)
        return ( ((hi >= 65 ? hi-55 : hi-48)<<4) | (lo >= 65 ? lo-55 : lo-48) )

    GetGreenPart(hex)
        hex = uppertext(hex)
        var
            hi = text2ascii(hex, 4)
            lo = text2ascii(hex, 5)
        return ( ((hi >= 65 ? hi-55 : hi-48)<<4) | (lo >= 65 ? lo-55 : lo-48) )

    GetBluePart(hex)
        hex = uppertext(hex)
        var
            hi = text2ascii(hex, 6)
            lo = text2ascii(hex, 7)
        return ( ((hi >= 65 ? hi-55 : hi-48)<<4) | (lo >= 65 ? lo-55 : lo-48) )

    GetColors(hex)
        hex = uppertext(hex)
        var
            hi1 = text2ascii(hex, 2)
            lo1 = text2ascii(hex, 3)
            hi2 = text2ascii(hex, 4)
            lo2 = text2ascii(hex, 5)
            hi3 = text2ascii(hex, 6)
            lo3 = text2ascii(hex, 7)
        return list(((hi1>= 65 ? hi1-55 : hi1-48)<<4) | (lo1 >= 65 ? lo1-55 : lo1-48),
            ((hi2 >= 65 ? hi2-55 : hi2-48)<<4) | (lo2 >= 65 ? lo2-55 : lo2-48),
            ((hi3 >= 65 ? hi3-55 : hi3-48)<<4) | (lo3 >= 65 ? lo3-55 : lo3-48))