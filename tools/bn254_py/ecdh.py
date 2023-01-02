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

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.

#     https://www.gnu.org/licenses/agpl-3.0.en.html

#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

#   You can be released from the requirements of the license by purchasing
#   a commercial license. Buying such a license is mandatory as soon as you
#   develop commercial activities involving the MIRACL Core Crypto SDK
#   without disclosing the source code of your own applications, or shipping
#   the MIRACL Core Crypto SDK with a closed source product.

#
# Python 3.7 Code to implement basic ECDH/ECDSA protocol API
# M.Scott August 2018
#

import hashlib
from bn254_py.constants import *

from bn254_py import big
from bn254_py import curve
from bn254_py.ecp import ECp
from bn254_py.ecp import generator
from bn254_py.ecp import mul

# Calculate a public/private EC GF(p) key pair.


def ECP_KeyPairGenerate(S):
    G = generator()

    if S is None:
        s = big.rand(curve.r)
    else:
        s = big.from_bytes(S) % curve.r

    Y = s * G

    SK = big.to_bytes(s)

    PK = Y.toBytes(False)
    return (SK, PK)


# Validate public key


def ECP_PublicKeyValidate(W):
    r = curve.r
    p = curve.p

    WP = ECp()
    if not WP.fromBytes(W):
        return ECDH_INVALID_PUBLIC_KEY

    nb = p.bit_length()
    k = 1
    k = k << (nb + 4) // 2
    k += p
    k //= r
    while k % 2 == 0:
        WP.dbl()
        k //= 2
    if k != 1:
        WP = k * WP
    if WP.isinf():
        return ECDH_INVALID_PUBLIC_KEY
    return 0


# Get Diffie-Hellman shared key


def ECP_SvdpDH(S, W):
    s = big.from_bytes(S)
    WP = ECp()
    if not WP.fromBytes(W):
        return ECDH_ERROR

    r = curve.r
    s %= r
    WP = s * WP

    if WP.isinf():
        return ECDH_ERROR
    x = WP.getx()

    K = big.to_bytes(x)

    return K


# create ECDSA signature


def ECP_SpDSA(S, F):
    FS = curve.EFS
    G = generator()
    m = hashlib.new(curve.SHA)
    m.update(F)
    H = m.digest()
    HS = m.digest_size
    if HS >= FS:
        B = H[0:FS]
    else:
        B = bytearray(FS)
        for i in range(0, HS):
            B[i + FS - HS] = H[i]

    #C = bytearray(FS)
    #D = bytearray(FS)

    r = curve.r
    s = big.from_bytes(S)
    f = big.from_bytes(B)

    c = 0
    d = 0
    while d == 0:
        u = big.rand(curve.r)
        w = big.rand(curve.r)  # masking
        V = G.copy()
        V = u * V
        vx = V.getx()
        c = vx % r
        if c == 0:
            continue
        u = big.modmul(u, w, r)
        u = big.invmodp(u, r)
        d = big.modmul(s, c, r)
        d += f
        d = big.modmul(d, w, r)
        d = big.modmul(d, u, r)

    C = big.to_bytes(c)
    D = big.to_bytes(d)

    return C, D


# verify signature


def ECP_SvDSA(P, F, C, D):
    FS = curve.EFS
    G = generator()

    m = hashlib.new(curve.SHA)
    m.update(F)
    H = m.digest()
    HS = m.digest_size
    if HS >= FS:
        B = H[0:FS]
    else:
        B = bytearray(FS)
        for i in range(0, HS):
            B[i + FS - HS] = H[i]
    c = big.from_bytes(C)
    d = big.from_bytes(D)
    f = big.from_bytes(B)

    r = curve.r
    if c == 0 or c >= r or d == 0 or d >= r:
        return False
    d = big.invmodp(d, r)
    f = big.modmul(f, d, r)
    h2 = big.modmul(c, d, r)

    WP = ECp()
    if not WP.fromBytes(P):
        return False
    P = mul(WP, h2, G, f)

    if P.isinf():
        return False
    d = P.getx() % r
    if c != d:
        return False
    return True
