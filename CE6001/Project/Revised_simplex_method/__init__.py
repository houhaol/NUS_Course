
import sys
import numpy as np
import math

class revised_simplex():
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

    def run(self, A, b, c, obj_type):
        # print("simplex")
        self.obj_type = obj_type
        self.A = A
        self.b = b
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
        # determine which enter the base by the relative cost coefficient

        
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
        # D = np.transpose(D)
        B_inverse = np.linalg.inv(B)
        
        pi = np.dot(base_c, B_inverse)
        current_cost = non_base_c - np.dot(pi, D)
        # print('current_cost',current_cost)
        # Check optimal
        if self.obj_type == 'min':
            if all(i >= 0 for i in current_cost):
                print('It\'s optimal')
                self.can_improve = False
                self.b = np.dot(B_inverse, self.b)
            most_negative_index = np.argmin(current_cost)
            enter_var = self.non_base[most_negative_index]  
        elif self.obj_type == 'max':
            if all(i <= 0 for i in current_cost):
                print('It\'s optimal')
                self.can_improve = False
                self.b = np.dot(B_inverse, self.b)
            most_negative_index = np.argmax(current_cost)
            enter_var = self.non_base[most_negative_index]
            # print('enter_var',enter_var)
        # determine which leave the base by calculating the ratio
        ratio = []
        min_ratio_index = -1
        # print('most', most_negative_index)
        A = np.dot(B_inverse, table[:-1, int(enter_var)])

        # Check the unboundness
        if all(i < 0 for i in A):
            raise Exception('It is unbounded')
        # print('possible',table)
        tmp_b = np.dot(B_inverse, self.b)
        # print('tmp_b', tmp_b)
        # print('A', A)
        for index,value in enumerate(A):
            if value > 0 and tmp_b[index]/value > 0:
                ratio.append(tmp_b[index]/value)
            else:
                ratio.append(math.inf)
        
        # min_raito leave the base
        # print('ratio', ratio)
        min_ratio_index = np.argmin(ratio)
        leave_var = self.base[min_ratio_index]
        # print('min_index, var', min_ratio_index, leave_var)
        
        # print(table)
        # print('B_inverse', B_inverse)
        # print('pi', pi)
        # print('non_base_c', non_base_c)
        # print('D', D)
        # print('current_cost', current_cost)
        # print('self.base', self.base)
        # print('self.non_base', self.non_base)
        # print('Corresponding value', self.b)
        # print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
        return enter_var, most_negative_index, leave_var, min_ratio_index


    def get_solution(self):
        all_variables = [0]*(len(self.base)+len(self.non_base))
        for index, base_var in enumerate(self.base):
            all_variables[int(base_var)] = self.b[index]
        # print(all_variables)
        print('Base variables',self.base)
        print('Corresponding value', self.b)
        z = np.concatenate((self.c.reshape(1,-1), np.zeros((1, len(self.b)))), axis = 1)
        print('Objecive value', np.sum(np.multiply(z, all_variables)))
        return None

