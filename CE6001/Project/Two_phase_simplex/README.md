Two-phase for max >=0 & min <=0:
1. python main.py -A [[6,5,-1],[10,20,0],[1,0,0]] -b [60,150,8] -c [500,450,0] -t max –m 2
2. python main.py -A [[1,1,-1,0,0],[2,-1,0,-1,0],[0,3,0,0,1]] -b [1,1,2] -c [-6,-3,0,0,0] -t max -m 2
6. python main.py -A [[2,1,1,0],[1,1,0,-1]] -b [6,4] -c [3,2,0,0] -t min –m 2
Infeasible:
3. python main.py -A [[1,2,0],[3,2,0],[1,3,-1]] -b [8,12,13] -c [1,1,0] -t max –m 2
4. python main.py -A [[2,-1,-2,0,0],[-2,3,1,-1,0],[1,-1,-1,0,-1]] -b [4,5,1] -c [1,-1,1,0,0] -t max –m 2
Unbounded:
5. python main.py -A [[6,5,-1,0,0],[10,20,0,-1,0],[1,0,0,0,-1]] -b [60,150,9] -c [500,450,0,0,0] -t max –m 2