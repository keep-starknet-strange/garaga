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
# Python 3.7 Code to implement basic BLS protocol API
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

# hash message m to curve point

G2_TAB = []


def init():
    global G2_TAB
    G = ecp2.generator()
    if G.isinf() :
        return False
    G2_TAB = pair.precomp(G)
    return True


def BLS_H(m):
    h = hashlib.shake_256()
    h.update(bytes(m, 'utf-8'))
    hm = big.from_bytes(h.digest(curve.EFS))
    HM = ECp()
    while not HM.set(hm):
        hm = hm + 1
    HM = curve.CurveCof * HM

    return HM


# generate key pair, private key SK, public key PK


def KeyPairGenerate():
    G = ecp2.generator()
    s = big.rand(curve.r)
    W = s * G
    SK = big.to_bytes(s)
    PK = W.toBytes(True)    #set to True to compress public key
    return (SK, PK)


# Sign message m using private key SK to return signature


def sign(m, SK):
    HM = BLS_H(m)
    s = big.from_bytes(SK)
    D = s * HM
    return D.toBytes(True)


# Verify signature given message m, the signature SIG, and the public key W


def verify(SIG, m, W):
    HM = BLS_H(m)
    D = ECp()
    D.fromBytes(SIG)
    if D.isinf() :
        return False
    if not (curve.r*D).isinf() :
        return False
    D = -D

    PK = ECp2()
    PK.fromBytes(W)


    # Use new multi-pairing mechanism
    r = pair.initmp()
    pair.another_pc(r, G2_TAB, D)
    pair.another(r, PK, HM)
    v = pair.miller(r)

    #.. or alternatively
    #    G=ecp2.generator()
    #    if G.isinf() :
    #        return False
    #    v = pair.double_ate(G, D, PK, HM)

    v = pair.fexp(v)
    if v.isone():
        return True
    return False
