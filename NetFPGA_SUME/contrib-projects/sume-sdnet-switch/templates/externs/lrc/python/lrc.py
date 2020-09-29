
"""
This file implements the lrc hash function in python
"""

import math


"""
Inputs:
  data_list: list of input data
  bit_width_list: list of bit widths corresponding to values in data_list
  result_width: the bit width of the result
"""
def lrc(data_list, bit_width_list, result_width):
    data_width = sum(bit_width_list)
    in_data = hexify(data_list, bit_width_list)
    result = 0
    mask = 2**result_width - 1
    for i in range(int(math.ceil(float(data_width)/float(result_width)))):
        word = in_data & mask
        result = result ^ word
        in_data = in_data >> result_width 
    return result

def hexify(data_list, bit_width_list):
    ret = 0
    for val, bits in zip(data_list, bit_width_list):
        mask = 2**bits -1
        ret = (ret << bits) + (val & mask)
    return ret

