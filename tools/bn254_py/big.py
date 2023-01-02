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

# Number Theoretic functions
# M Scott August 2013
#

#import math
#import types
import random

from bn254_py import curve

def to_bytes(b):
    return b.to_bytes(curve.EFS, byteorder='big')

def from_bytes(B):
    return int.from_bytes(B, byteorder='big')

# extract i-th bit
def bit(k, i):
    if i == 0:
        return k & 1
    return ((k >> i) & 1)

# gcd
def gcd(x, y):
    a = x
    b = y
    while b != 0:
        a, b = b, a % b
    return a

# inverse mod prime p
def invmodp(a, p):
    n = p
    x = a % n
    if x == 0:
        return x
    kn = n
    if x < 0:
        x += n
    if gcd(x, n) != 1:
        return 0
    a = 1
    la = 0
    while x > 1:
        q, r = divmod(n, x)
        t = la - a * q
        la = a
        a = t
        n = x
        x = r
    if a < 0:
        a += kn
    return a

# Modular arithmetic
def modmul(a1, b1, p):
    a = a1 % p
    b = b1 % p

    if a < 0:
        a += p
    if b < 0:
        b += p
    return a * b % p


def modadd(a, b, p):
    c = a + b
    if c >= p:
        c -= p
    return c


def modsub(a, b, p):
    c = a - b
    if c < 0:
        c += p
    return c


def moddiv(a, b, p):
    i = invmodp(b, p)
    if i != 0:
        return modmul(a, i, p)
    return 0

# modular square root. Fails spectacularly if p=1 mod 8
def sqrtmodp(a, p):
    if p % 4 == 3:
        return pow(a, (p + 1) // 4, p)

    if p % 8 == 5:
        b = (p - 5) // 8
        i = a * 2
        v = pow(i, b, p)
        i = modmul(i, v, p)
        i = modmul(i, v, p)
        i -= 1
        r = modmul(a, v, p)
        r = modmul(r, i, p)
        return r

    return 0


# chinese remainder theorem
def crt(rp, p, rq, q):
    c = invmodp(p, q)
    t = modmul(c, rq - rp, q)
    return t * p + rp

# find jacobi symbol for (x/p). Only defined for
# positive x and p, p odd. Otherwise returns 0
def jacobi(a, p):
    if a < 1 or p < 2 or p % 2 == 0:
        return 0
    n = p
    x = a % n
    m = 0
    while n > 1:
        if x == 0:
            return 0
        n8 = n % 8
        k = 0
        while x % 2 == 0:
            k += 1
            x //= 2
        if k % 2 == 1:
            m += (n8 * n8 - 1) // 8
        m += (n8 - 1) * (x % 4 - 1) // 4
        t = n
        t %= x
        n = x
        x = t
        m %= 2
    if m == 0:
        return 1
    else:
        return -1

# random number < m
def rand(m):
    return random.SystemRandom().randint(2, m - 1)
