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
# bigs modulo n
# M.Scott August 2013
#

import copy
from bn254_py import big
from bn254_py import curve

class Fp:
    p = curve.p

    def __init__(self, x=None):
        if (x is None or x == 0):
            self.x = 0
        else:
            if (x < 0):
                y = -x
                self.x = Fp.p - (y % Fp.p)
            else:
                self.x = x % Fp.p

    def copy(self):
        return copy.copy(self)

    def __add__(self, other):
        return Fp(big.modadd(self.x, other.x, Fp.p))

    def __iadd__(self, other):
        self.x = big.modadd(self.x, other.x, Fp.p)
        return self

    def __sub__(self, other):
        return Fp(big.modsub(self.x, other.x, Fp.p))

    def __isub__(self, other):
        self.x = big.modsub(self.x, other.x, Fp.p)
        return self

    def __mul__(self, other):
        return Fp(big.modmul(self.x, other.x, Fp.p))

    def __imul__(self, other):
        self.x = big.modmul(self.x, other.x, Fp.p)
        return self

    def __neg__(self):
        return Fp(Fp.p - self.x)

    def muli(self, other):
        return Fp((other * self.x) % Fp.p)

    def inverse(self):
        return Fp(big.invmodp(self.x, Fp.p))

    def div2(self):
        if self.x % 2 == 1:
            return Fp((Fp.p + self.x) // 2)
        else:
            return Fp(self.x // 2)

    def __eq__(self, other):
        return self.x == other.x

    def __ne__(self, other):
        return self.x != other.x

    def iszero(self):
        if self.x == 0:
            return True
        return False

    def isone(self):
        if self.x == 1:
            return True
        return False

    def pow(self, other):
        return Fp(pow(self.x, other, Fp.p))

    def qr(self):
        return pow(self.x,(Fp.p-1)//2,Fp.p)

    def jacobi(self):
        return big.jacobi(self.x, Fp.p)

    def gcd(self):
        return big.gcd(self.x, Fp.p)

    def sqrt(self):
        return Fp(big.sqrtmodp(self.x, Fp.p))

    def int(self):
        return self.x

    def rand(self):
        self.x = big.rand(Fp.p)
        return self
