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
# Fp^4 CLass - towered over Fp^2
# M.Scott August 2018
#

import copy
from bn254_py import curve
from bn254_py.fp2 import Fp2
from bn254_py.fp import Fp

class Fp4:
    def __init__(self, a=None, b=None):
        if b is None:
            if a is None:
                self.a = Fp2()
                self.b = Fp2()
            else:
                self.a = a.copy()
                self.b = Fp2()
        else:
            self.a = a.copy()
            self.b = b.copy()

    def copy(self):
        return copy.deepcopy(self)

    def get(self):
        return(self.a, self.b)

    def set(self, a, b):
        self.a = a
        self.b = b
        return self

    def __add__(self, other):
        return Fp4(self.a + other.a, self.b + other.b)

    def __iadd__(self, other):
        self.a += other.a
        self.b += other.b
        return self

    def __sub__(self, other):
        return Fp4(self.a - other.a, self.b - other.b)

    def __isub__(self, other):
        self.a -= other.a
        self.b -= other.b
        return self

    def __eq__(self, other):
        return (self.a == other.a and self.b == other.b)

    def __ne__(self, other):
        return (self.a != other.a or self.b != other.b)

    def conj(self):
        return Fp4(self.a, -self.b)

    def sqr(self):
        newa = (self.a + self.b) * (self.a + self.b.mulQNR())
        self.b *= self.a
        newa -= self.b
        newa -= self.b.mulQNR()
        self.b += self.b
        self.a = newa.copy()
        return self

    def times_i(self):
        t = self.b.copy()
        self.b=self.a
        t = t.mulQNR()
        self.a=t
        return self

    def __imul__(self, other):
        t1 = self.a * other.a
        t2 = self.b * other.b
        t3 = other.a + other.b
        self.b += self.a
        self.b *= t3
        self.b -= t1
        self.b -= t2
        self.a = t1 + t2.mulQNR()
        return self

    def __mul__(self, other):
        R = self.copy()
        if R == other:
            R.sqr()
        else:
            R *= other
        return R

    def muls(self, other):  # multiple Fp4	 by Fp2
        return Fp4(self.a * other, self.b * other)

    def __neg__(self):
        return Fp4(-self.a, -self.b)

    def real(self):
        return self.a

    def imaginary(self):
        return self.b

    def iszero(self):
        if self.a.iszero() and self.b.iszero():
            return True
        return False

    def isone(self):
        if self.a.isone() and self.b.iszero():
            return True
        return False

    def rand(self):
        r = Fp2()
        r.rand()
        self.a = r.copy()
        r.rand()
        self.b = r.copy()
        return self

    def __str__(self):		# pretty print
        return "[%s,%s]" % (self.a, self.b)

    def mulQNR(self):		# assume  QNR=2^i+sqrt(-1)
        return Fp4(self.b.mulQNR(), self.a)

    def inverse(self):
        w = self.conj()
        c = self.a * self.a - (self.b * self.b).mulQNR()
        c = c.inverse()
        w.a *= c
        w.b *= c
        return w

    def powq(self):
        X = Fp2(Fp(curve.Fra), Fp(curve.Frb))
        X3 = X * X * X
        return Fp4(self.a.conj(), self.b.conj() * X3)
