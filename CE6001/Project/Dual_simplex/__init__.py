import sys
import numpy as np
import math

class dual_simplex():
    def __init__(self): 
        self.A = []
        self.b = []
        self.c = []
        self.obj_type = 'max'
        self.enter_record = []
        self.leave_record = []
        self.base = []
        self.non_base = []
        self.can_improve = True
        self.Xb = []

    def run(self, A, b, c, obj_type):
        # print("simplex")
        self.obj_type = obj_type
        self.A = A
        self.b = b
        if self.obj_type == 'max':
            self.c = -c
        else:
            self.c = c
        
        # add variable and build the initial table
        
        table = self.init_table()
        
        while self.can_improve:
            # print(self.base)
            # print(self.base_val)
            self.find_pivot(table)
        self.get_solution()
        
    
    def init_table(self):
        # add slack variables
        slack_matrix = np.identity(len(self.b))
        # A matrix with slack variables
        new_A = np.concatenate((self.A, slack_matrix), axis = 1)
        # Concatenate A with b
        b = np.reshape(self.b, (-1,1))
        table_AB = np.concatenate((new_A, b), axis = 1)
        # integrate c into table
        c = np.reshape(self.c, (1,-1))
        c_with_slack = np.concatenate((c, np.zeros((1, len(self.b)+1))), axis = 1)
        table_ABC = np.concatenate((table_AB, c_with_slack), axis =0)

        # Initial base variables
        num_variables = new_A.shape[1]
        self.base = [0]*(len(self.b))

        for i in range(len(self.b)):
            self.base[i] = str(self.A.shape[1] + i)
        for j in range(num_variables - len(self.base)):
            self.non_base.append(str(j)) 
        return table_ABC

    def find_pivot(self, table):
        var_enter,enter_loc, var_leave, leave_loc = self.enter_leave(table)
        self.base_update(var_enter,enter_loc, var_leave, leave_loc)

        # Check the denegeracy

    def base_update(self, var_enter,enter_loc, var_leave, leave_loc):
        if self.can_improve == True:
            self.enter_record.append(var_enter)
            self.leave_record.append(var_leave)
            # print('leave_enter', var_leave, var_enter)
            # print('leave_enter_loc', leave_loc, enter_loc)

            self.base[leave_loc] = str(var_enter)
            
            self.non_base[enter_loc] = str(var_leave)
            # print('base', self.base)
            # print('non', self.non_base)

    def enter_leave(self, table):
        # determine which leave the base by selecting the most negative.
        B_T = np.zeros((len(self.base), len(self.base)))
        base_c = np.zeros((len(self.base)))
        non_base_c = np.zeros((len(self.non_base)))
        D = np.zeros((len(self.b), len(self.non_base)))

        for i in range(len(self.base)):
            B_T[i] = table[:-1, int(self.base[i])]
            base_c[i] = table[-1, int(self.base[i])] 
        
        for j in range(len(self.non_base)):
            non_base_c[j] = table[-1, int(self.non_base[j])]
            D[:,j] = table[:-1, int(self.non_base[j])]

        B = np.transpose(B_T)
        B_inverse = np.linalg.inv(B)

        Xb = np.dot(B_inverse, self.b)

        # Check optimal
        # if self.obj_type == 'min':
        if all(i >= 0 for i in Xb):
            print('It\'s optimal')
            self.can_improve = False
            self.b = np.dot(B_inverse, self.b)
            # self.Xb = Xb
        min_value_index = np.argmin(Xb)
        leave_var = self.base[min_value_index]

        # determine enter the base
        # for non-basic, compute the constraint coefficients
        coefficients_matrix = np.dot(B_inverse, D)
        numerator = np.dot(base_c, coefficients_matrix) - non_base_c

        row_to_coefficients = coefficients_matrix[min_value_index, :]
        if all(i > 0 for i in row_to_coefficients):
            raise Exception('All positive - no entering variable. Remains primal infeasibility. Thus, LP is infeasible')

        ratio = [0]*len(row_to_coefficients)
        for index, element in enumerate(row_to_coefficients):
            if element < 0:
                ratio[index] = numerator[index]/element
            else:
                ratio[index] = math.inf

        min_positive_index = np.argmin(ratio)
        enter_var = self.non_base[min_positive_index]

        # print(coefficients_matrix)
        # print(table)
        # print('B_inverse', B_inverse)
        # print('non_base_c', non_base_c)
        # print('D', D)
        # print('self.base', self.base)
        # print('self.non_base', self.non_base)
        return enter_var, min_positive_index, leave_var, min_value_index


    def get_solution(self):
        # all_variables = [0]*(len(self.base)+len(self.non_base))
        # for index, base_var in enumerate(self.base):
        #     all_variables[int(base_var)] = self.Xb[index]
        # print(all_variables)
        # z = np.concatenate((self.c.reshape(1,-1), np.zeros((1, len(self.b)))), axis = 1)
        # print('Objecive value', np.sum(np.multiply(z, all_variables)))

        all_variables = [0]*(len(self.base)+len(self.non_base))
        for index, base_var in enumerate(self.base):
            all_variables[int(base_var)] = self.b[index]
        # print(all_variables)
        print('Base variables',self.base)
        print('Corresponding value', self.b)
        z = np.concatenate((self.c.reshape(1,-1), np.zeros((1, len(self.b)))), axis = 1)
        if self.obj_type == 'max':
            print('Objecive value', -np.sum(np.multiply(z, all_variables)))
        else:
            print('Objecive value', np.sum(np.multiply(z, all_variables)))
        return None
        