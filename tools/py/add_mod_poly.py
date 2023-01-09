import random
import copy
from tools.py.polynome import Polynome, load_coeff_py as load_coeff, to_polynome_py as to_polynome


# a and b must both be <= P(t)
def add_mod_poly(a:int, b:int):
    m,t,s,P=load_coeff()
    A = to_polynome(a)
    B = to_polynome(b)
    C=A+B

    def debug_return(R:Polynome, i:int):
        if R(t)!=(a+b)%P(t):
            print("WRONG" ,i)
            print("C", C)
            print("R", R)
            print("R(t)", R(t))
            print("(a+b)%P(t)", (a+b)%P(t))
            print('T', to_polynome((a+b)%P(t)))
            raise Exception("debug_return")
        else:
            # print("Correct" ,i)
            return R

    if C[4]==P[4]:
        if C[3]==P[3]:
            if C[2]==P[2]:
                if C[1]==P[1]:
                    if C[0]==P[0]:
                        return debug_return(C-C, 0)
                    else:
                        if C[0]>P[0]:
                            return debug_return(C-P,1)
                        else:
                            return debug_return(C, 2)
                else:
                    if C[1]>P[1]:
                        return debug_return(C-P, 3)
                    else:
                        return debug_return(C, 4)
            else:
                if C[2]>P[2]:
                    return debug_return(C-P, 5)
                else:
                    return debug_return(C, 6)
        else:
            if C[3]>P[3]:
                return debug_return(C-P, 7)
            else:
                return debug_return(C, 8)
    else:
        # 
        if C[4]>P[4]:
            return debug_return(C-P, 9)
            
        else:

            if C[3]>t and C[4]==(P[4]-1):
                C_COPY = copy.copy(C)
                C_COPY[3]=C_COPY[3]%t
                C_COPY[4]=C_COPY[4]+1
                if C_COPY[3] > P[3]:
                    return debug_return(C_COPY-P, 10)
                else:
                    return debug_return(C, 11)
            else:
                return debug_return(C, 12)


if __name__ == "__main__":
    m, t, s, P = load_coeff()
    p = P(t)

    a = p - 123
    b = p - p // 7

    C=add_mod_poly(a,b)
    ntrue=0
    wrongs=[]
    for i in range(0,50):
        a=random.randint(0,p)
        b=random.randint(0,p)
        C=add_mod_poly(a,b)
        if C(t)==(a+b)%p:
            ntrue+=1
        else:
            print('wrong')
            print(a) 
            print(b)
            print("a+b=",a+b)
            print("a+b%p=",(a+b)%p)
            print(C)
            print("C(t)=",C(t))
            wrongs.append((a,b))
    print(ntrue)

    # print(C)
    # print(int(C(t)))
    # print((a+b)%p)
    special_cases=[]

    special_cases.append([P(t), P(t)-1])
    special_cases.append([P(t), P(t)])
    special_cases.append([Polynome([35, t-1, t-1, t-1, t-1])(t), Polynome([0, 2, t-1, t-1, 0])(t)])
    special_cases.append([Polynome([35, t-1, t-1, t-1, t-1])(t), Polynome([0, 3, t-1, t-1, 0])(t)])

    special_cases.append([Polynome([35, t-1, t-1, t-1, t-1])(t), Polynome([0, t-1, t-1, t-1, 0])(t)])
    special_cases.append([Polynome([35, t-1, t-1, t-1, t-1])(t), Polynome([35, t-1, t-1, t-1, 0])(t)])

    for x in special_cases:

        C=add_mod_poly(x[0], x[1])
