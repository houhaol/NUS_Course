import sys
import numpy as np
import math

class two_phase_simplex():
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
        if self.obj_type == 'max':
            self.c = c
        else:
            self.c = -c
        # add variable and build the initial table
        
        table = self.init_table()
        
        while self.optimal(table):
            pivot = self.find_pivot(table)
            print(pivot)
            table = self.pivot(table, pivot)
            # print('table', table)
        self.get_solution(table)

    def phase_one(self,table):
        # print('table',table)
        while table[-1,-1] > 0:
            # Conver to canonical form
            pivot = self.find_pivot(table)
            # print('pivot',pivot)
            # print('self.base', self.base)
            table = self.pivot(table, pivot)
            # print('table',table)
            # tmp_table = np.delete(table,len(self.c)+pivot[1],axis=1)
            # print(tmp_table)
            if  all(i <= 0 for i in table[-1,:-len(self.b)]) and table[-1,-1]>0:
                raise Exception('Infeasible')
        # optimal solution for phase one
        # print('table',table)
        phase_two_table = np.delete(table, np.s_[table.shape[1]-len(self.b)-1:-1], axis=1)
        phase_two_table = np.delete(phase_two_table, -1, axis = 0)
        # print('phase_two_table',phase_two_table)
        return phase_two_table
    
    def init_table(self):
        # add slack/artifical variables
        slack_matrix = np.identity(len(self.b))
        # A matrix with slack/artifical variables
        new_A = np.concatenate((self.A, slack_matrix), axis = 1)
        # Concatenate A with b
        b = np.reshape(self.b, (-1,1))
        table_AB = np.concatenate((new_A, b), axis = 1)
        # integrate c into table
        c = np.reshape(self.c, (1,-1))
        c_with_slack = np.concatenate((c, np.zeros((1, len(self.b)+1))), axis = 1)
        table_ABC = np.concatenate((table_AB, c_with_slack), axis =0)
        w = np.zeros((table_ABC.shape[1]))
        w[c.shape[1]:-1] = -1
        table_ABCW = np.concatenate((table_ABC, np.reshape(w,(1,-1))), axis=0)

        # convert to canonical form
        for i in range(len(self.b)):
            table_ABCW[-1,:] += table_ABCW[i,:]
        # print("table_ABCW",table_ABCW)
        # Initial base variables
        self.base = [0]*(len(self.b))
        for i in range(len(self.b)):
            self.base[i] = str(self.A.shape[1] + i)
        phase_two_table = self.phase_one(table_ABCW)
        # num_variables = new_A.shape[1]
   
        return phase_two_table
        
    

    def find_pivot(self, table):
        var_enter = self.enter(table)
        var_leave = self.var_leave(table, var_enter)
        # print('enter, leave', var_enter,var_leave)
        
        self.base_update(var_enter, var_leave)
        # print("self.base,",self.base)
        # Check the denegeracy
        
        
        return [var_enter, var_leave]

    def base_update(self, var_enter, var_leave):
        self.enter_record.append(var_enter)
        self.leave_record.append(var_leave)
        self.base[var_leave] = str(var_enter)


    def enter(self, table):
        # determine which enter the base by selecting the most postive
        last_row = table[-1, :-1]
        # print('last_row', last_row)
        index = np.argmax(last_row)
        # most_postive_var = max(last_row)
        return index

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
        
        # print('ratio',ratio)
        min_ratio_index = np.argmin(ratio)
        return min_ratio_index

    def pivot(self, table, index):
        var_enter = index[0]
        var_leave = index[1]

        # Perform G-J operations
        pivot_value = table[var_leave, var_enter]
        table[var_leave] = [val/pivot_value for val in table[var_leave]]
        # print('pivot_table',table)
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
            print('Objetive value is: %r', -table[-1, -1])
        else:
            print('Base variables: ', self.base)
            print('Corresponding value :', table[:-1, -1])
            print('Objetive value is: %r', table[-1, -1])
            

        # print('enter: %r', self.enter_record)
        # print('leave: %r', self.leave_record)
        # print(pivot_indecs)
        # print(table)
        

        
        return None