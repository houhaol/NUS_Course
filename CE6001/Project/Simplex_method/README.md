Simplex method for solving linear programming.

Make sure your input as the standard form.

When objective function is max, for all constraints should less than or equal to certain number.

When objective function is min, for all constraints should greater than or equal to certain number.

Cconvert the objective function type if necessary. For example, all constraints are less than or equal to, but objective function is a min problem. Then users should convert the objective function to a max problem by multiplying -1 on both sides.

It is robust to check the boundness. 

Simplex method examples:
Baisc examples standard form:
1. python main.py -A [[6,5],[10,20],[1,0]] -b [60,150,8] -c [500,450] -t max –m 1
2. python main.py -A [[2,1,1],[4,2,3],[2,5,5]] -b [14,28,30] -c [1,2,-1] -t max –m 1
3. python main.py -A [[1,1,1],[0,1,2],[-1,2,2]] -b [6,8,4] -c [2,10,8] -t min –m 1
4. python main.py -A [[2,1],[1,1]] -b [6,4] -c [3,2] -t min –m 1
Check unboundness examples:
5. python main.py -A [[1,0,-3,3],[0,1,-8,4]] -b [6,4] -c [0,0,3,-1] -t max –m 1
6. python main.py -A [[1,-2],[1,0],[0,-1]] -b [6,10,-1] -c [3,5] -t max –m 1

