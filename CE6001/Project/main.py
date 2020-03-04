import Simplex_method
import Dual_simplex
import Revised_simplex_method
import Two_phase_simplex
import Two_phase_revised_simplex
import sys
import getopt
import ast
import numpy as np

def prase_arg(argv):
    A = []
    b = []
    c = []
    obj_type = ''
    method = 0

    try:
        opts, args = getopt.getopt(argv[1:], "hA:b:c:t:m:", ["help", "A_matrix=", "b=", "c=", "obj_type=", "method="])
    
    except getopt.GetoptError:
        print("A_matrix= b = c=, obj_type = method=")
        sys.exit()
    
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print('convert and make sure max <=, min >=')
            print('main.py -A <A_matrix> -b <b_vector> -c <c_vector> -t <obj_type max or min> -m <method selection: 1 - simplex, 2 - revised_simplex, 3 - dual_simplx>')

            print('or: main.py --A_matrix=<A_matrix> --b=<b_vector> --c=<c_vector> --obj_type=<obj_type max or min> --method=<method selection: 1 - simplex, 2 - two phase simplex method, 3 - revised_simplex, 4 - two phase revised simplex method, 5 - dual_simplx>')
            sys.exit()
        elif opt in ("-A", "--A_matrix"):
            A = arg
        elif opt in ("-b", "--b"):
            b = arg
        elif opt in ("-c", "--c"):
            c = arg
        elif opt in ("-t", "--obj_type"):
            obj_type = arg
        elif opt in ("-m", "--method"):
            method = int(arg)

    #Check input
    if not A or not b or not c:
        print('Wrong input for A,b,c; -h for more info')
        sys.exit()
    
    elif obj_type != 'max' and obj_type != 'min':
        print('Wrong input for objective function type; -h for more info')
        sys.exit()

    elif method != 1 and method != 2 and method != 3 and method !=4 and method !=5:
        print('Wrong input for method selection; -h for more info')
        sys.exit()

    A = np.array(ast.literal_eval(A))
    b = np.array(ast.literal_eval(b))
    c = np.array(ast.literal_eval(c))


    return A,b,c,obj_type,method

if __name__ == "__main__":
    
    # A = [[15, 20, 25], [35, 60, 60], [20, 30, 25], [0, 250, 0]]
    # b = [1200, 3000, 1500, 500]
    # c = [300, 250, 450]
    
    A,b,c,obj_type,method = prase_arg(sys.argv)

    # Run
    if method == 1:
        Simplex_method.simplex().run(A,b,c, obj_type)
    if method == 2:
        Two_phase_simplex.two_phase_simplex().run(A,b,c, obj_type)
    elif method == 3:
        Revised_simplex_method.revised_simplex().run(A,b,c,obj_type)
    elif method == 4:
        Two_phase_revised_simplex.two_pahse_revised_simplex().run(A,b,c, obj_type)
    elif method == 5:
        Dual_simplex.dual_simplex().run(A,b,c, obj_type)






