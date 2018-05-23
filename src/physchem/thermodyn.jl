# Note: Inline functions are more efficient than referencing Constants.T_0.


"""
    c2k(temp)

Convert temperature in Celsius to Kelvin.
"""
function c2k(temp)
    return temp + 273.15
end  # function c2k


"""
    k2c(temp)

Convert temperature in Kelvin to Celsius.
"""
function k2c(temp)
    return temp - 273.15
end  # function c2k
