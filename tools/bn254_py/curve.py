#!/usr/bin/env python3

#
# Copyright (c) 2012-2020 MIRACL UK Ltd.
#
# This file is part of MIRACL Core
# (see https://github.com/miracl/core).
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# lib curve constants

from bn254_py.constants import *

SHA = 'sha256'   # hash type to use with this curve
EFS = 32   # Elliptic curve Field Size in bytes
CurveType = WEIERSTRASS
CurveCof = 1

SexticTwist = D_TYPE
SignOfX = 1
PairingFriendly = BN
QNRI = 0

x = 0x4080000000000001 # WRONG ! 
x = 4965661367192848881 # correct for bn254
# x = 4593689212103950336 # paper fast 
p = 36*x**4 + 36*x**3 + 24*x**2 + 6 * x + 1
if SignOfX == NEGATIVEX:
    p = 36 * x * x * x * x - 36 * x * x * x + 24 * x * x - 6 * x + 1
else:
    p = 36 * x * x * x * x + 36 * x * x * x + 24 * x * x + 6 * x + 1

t = 6 * x * x + 1
r = p + 1 - t

# elliptic curve
A = 0
B = 2

# generator point on G1
Gx = p - 1
Gy = 1

# Frobenius constant
Fra = 0x1B377619212E7C8CB6499B50A846953F850974924D3F77C2E17DE6C06F2A6DE9
Frb = 0x9EBEE691ED1837503EAB22F57B96AC8DC178B6DB2C08850C582193F90D5922A

# Generator point on G2
Pxa = 0x61A10BB519EB62FEB8D8C7E8C61EDB6A4648BBB4898BF0D91EE4224C803FB2B
Pxb = 0x516AAF9BA737833310AA78C5982AA5B1F4D746BAE3784B70D8C34C1E7D54CF3
Pya = 0x21897A06BAF93439A90E096698C822329BD0AE6BDBE09BD19F0E07891CD2B9A
Pyb = 0xEBB2B0E7C8B15268F6D4456F5F38D37B09006FFD739C9578A2D1AEC6B3ACE9B
