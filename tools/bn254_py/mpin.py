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
# Python 3.7 Code to implement basic MPIN protocol API
# M.Scott August 2018
#

import hashlib
#from bn254 import ecp
from bn254_py import ecp2
from bn254_py import curve
from bn254_py import big
from bn254_py.ecp import ECp
from bn254_py.ecp2 import ECp2
from bn254_py import pair
from bn254_py.fp12 import Fp12
from bn254_py.fp12 import one

# hash ID to point on curve

def H(mpin_id):
    p = curve.p
    h = hashlib.new(curve.SHA)
    h.update(bytes(mpin_id, 'utf-8'))
    x = big.from_bytes(h.digest())
    x %= p
    P = ECp()
    while not P.set(x):
        x = x + 1
    P = curve.CurveCof * P
    return P


def random_generate():
    s = big.rand(curve.r)
    Z = big.to_bytes(s)
    return Z


def get_server_secret(Z):
    Q = ecp2.generator()
    s = big.from_bytes(Z)
    Q = s * Q
    return Q.toBytes(False)


def get_client_secret(Z, ID):
    P = H(ID)
    s = big.from_bytes(Z)
    P = s * P
    return P.toBytes(False)


# subtract pin.ID from Secret key SK to create Token


def extract_pin(ID, PIN, SK):
    P = H(ID)
    P = -(PIN * P)
    S = ECp()
    if not S.fromBytes(SK):
        return bytearray(0)
    S.add(P)
    # S.affine()
    return S.toBytes(False)


# U=xH(ID)


def client_1(ID, X):
    P = H(ID)
    if X:
        w = big.from_bytes(X)
    else:
        w = big.rand(curve.r)
        X = big.to_bytes(w)
    P = w * P
    return (X, P.toBytes(False))


# reconstitute Client secret S from Token and PIN
# V=(x+y)S


def client_2(X, Y, ID, PIN, TK):
    P = H(ID)

    S = ECp()
    if not S.fromBytes(TK):
        return bytearray(0)
    x = big.from_bytes(X)
    y = big.from_bytes(Y)

    x = (x + y) % curve.r
    x = curve.r - x

    S.add(PIN * P)

    S = x * S
    return S.toBytes(False)


# authenticate


def server(ID, Y, SS, U, V):
    P = H(ID)
    y = big.from_bytes(Y)

    Q = ecp2.generator()

    P = y * P

    sQ = ECp2()
    if not sQ.fromBytes(SS):
        return (False, Fp12(), Fp12())

    TU = ECp()
    if not TU.fromBytes(U):
        return (False, bytearray(0), bytearray(0))

    TV = ECp()
    if not TV.fromBytes(V):
        return (False, bytearray(0), bytearray(0))

    TU.add(P)
    # TU.affine()

    r = pair.double_ate(Q, TV, sQ, TU)
    r = pair.fexp(r)

    if r.isone():
        return (True, bytearray(0), bytearray(0))


# failed - diagnose it
    E = r.toBytes()
    r = pair.e(Q, TU)
    F = r.toBytes()
    return (False, E, F)

MAXPIN = 10000
TS = 10
TRAP = 200

def kangaroo(E, F):
    e = Fp12()
    e.fromBytes(E)
    f = Fp12()
    f.fromBytes(F)

    # Pollards Kangaroos
    t = f.copy()

    distance = []
    table = []
    s = 1
    for m in range(0, TS):
        distance.append(s)
        table.append(t.copy())
        s *= 2
        t.usqr()

    t = one()
    # set trap
    dn = 0
    for j in range(0, TRAP):
        i = t.a.a.a.int() % TS
        t *= table[i]
        dn += distance[i]


# release wild kangaroo
    f = t.copy()
    f.conj()
    steps = 0
    dm = 0
    while dm - dn < MAXPIN:
        steps = steps + 1
        if steps > 4 * TRAP:
            break
        i = e.a.a.a.int() % TS
        e *= table[i]
        dm += distance[i]
        if e == t:
            res = dm - dn
            break
        if e == f:
            res = dn - dm
            break

    if steps > 4 * TRAP or dm - dn >= MAXPIN:
        res = 0
    return res


def add_G1(A, B):
    """ Add two points in G1: C = A + B """
    A1 = ECp()
    B1 = ECp()
    if not A1.fromBytes(A):
        return None
    if not B1.fromBytes(B):
        return None
    A1.add(B1)
    return A1.toBytes(False)


def add_G2(A, B):
    """ Add two points in G2: C = A + B """
    A1 = ECp2()
    B1 = ECp2()
    if not A1.fromBytes(A):
        return None
    if not B1.fromBytes(B):
        return None
    A1.add(B1)
    return A1.toBytes(False)
