import sys
import numpy as np
import math

class simplex():
    def __init__(self):
        self.A = []
        self.b = []
        self.c = []
        self.obj_type = 'max'
        self.enter_record = []
        self.leave_record = []
        self.base = []

    def run(self, A, b, c, obj_type):
        # print("simplex")
        self.obj_type = obj_type
        self.A = A
        self.b = b
        self.c = c

        if self.obj_type == 'min':
            # convert to transpose and then feed into init_table
            self.A = np.transpose(A)
            self.b = np.transpose(c)
            self.c = np.transpose(b)
        
        # add variable and build the initial table
        
        table = self.init_table()
        
        while self.optimal(table):
            pivot = self.find_pivot(table)
            table = self.pivot(table, pivot)

        self.get_solution(table)
        
    
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
        # num_variables = new_A.shape[1]
        self.base = [0]*(len(self.b))

        for i in range(len(self.b)):
            self.base[i] = str(self.A.shape[1] + i)
        return table_ABC
        
        # # Convect to the dual one if it is min
        # if self.obj_type = 'min':
        #     # Concatenate A with b
        #     b = np.reshape(self.b, (-1,1))
        #     table_AB = np.concatenate((self.A, b), axis = 1)
        #     # integrate c into table
        #     c = np.reshape(self.c, (1,-1))
        #     c_with_obj_value = np.concatenate((c, np.zeros((1,1))), axis = 1)
        #     table_ABC = np.concatenate((table_AB, c_with_obj_value), axis =0)

        #     table_ABC_transpose = table_ABC.T

        #     # add slack variables
        #     slack_matrix = np.identity((table_ABC_transpose.shape[0]-1))
        #     slack_with_z = np.concatenate(slack_matrix, np.zeros(1, slack_matrix.shape[0]))
        # return table_ABC_transpose
 


    def find_pivot(self, table):
        var_enter = self.enter(table)
        var_leave = self.var_leave(table, var_enter)
        self.base_update(var_enter, var_leave)
        


        # Check the denegeracy
        
        
        return [var_enter, var_leave]

    def base_update(self, var_enter, var_leave):
        self.enter_record.append(var_enter)
        self.leave_record.append(var_leave)
        self.base[var_leave] = str(var_enter)


    def enter(self, table):
        # determine which enter the base by selecting the most postive
        last_row = table[-1, :-1]
        most_postive_index = np.argmax(last_row)
        # most_postive_var = max(last_row)

        
        return most_postive_index

    def var_leave(self, table, enter_index):
        # determine which leave the base by choosing the minimal ratio
        ratio = []
        min_ratio_index = -1
        is_unboundness = []

        for index, value in enumerate(table[:-1, enter_index]):
    
            # Check the unboundness
            if value != 0:
                is_unboundness.append(table[index, -1]/value)
            
            if value != 0 and table[index, -1]/value > 0:
                ratio.append(table[index, -1]/value)
            else:
                ratio.append(math.inf)
                
        if all(i <= 0 for i in is_unboundness):
                raise Exception('It is unbounded')
        
        # min_ratio = min(ratio)
        min_ratio_index = np.argmin(ratio)
        return min_ratio_index

    def pivot(self, table, index):
        var_enter = index[0]
        var_leave = index[1]

        # Perform G-J operations
        pivot_value = table[var_leave, var_enter]
        table[var_leave] = [val/pivot_value for val in table[var_leave]]

        for i, _ in enumerate(table):
            if i != var_leave:
                row_multiply_scale = [y * table[i, var_enter] for y in table[var_leave]]
                table[i] = [x - y for x,y in zip(table[i], row_multiply_scale)]
        return table


    # optimal condiation, last row are all non-postive  
    def optimal(self, table):
        can_improve = False
        last_row = table[-1,:-1]
        for i in last_row:
            if i > 0:
                can_improve = True
        return can_improve

    

    def get_solution(self, table):
        # num_variables = table.shape[1]-1
        
        if self.obj_type == 'max':
            print('Base variables: ', self.base)
            print('Corresponding value :', table[:-1, -1])
        if self.obj_type == 'min':
            # print('Dual base variables: ', self.base)
            # print('Corresponding value :', table[:-1, -1])

            # The primal base variables and their values corresponding to slack variable columns
            base = []
            for i in range(len(self.b)):
                base.append(str(i))
            print('Base variables: ', base)
            print('Corresponding value :', -table[-1, self.A.shape[1]:-1])


        # print('enter: %r', self.enter_record)
        # print('leave: %r', self.leave_record)
        # print(pivot_indecs)
        # print(table)
        print('Objetive value is: %r', -table[-1, -1])

        
        return None       