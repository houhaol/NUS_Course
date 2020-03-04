Simplex method examples:
Baisc examples:
1. python main.py -A [[6,5],[10,20],[1,0]] -b [60,150,8] -c [500,450] -t max –m 3
2. python main.py -A [[2,1,1],[4,2,3],[2,5,5]] -b [14,28,30] -c [1,2,-1] -t max –m 3
3. python main.py -A [[5,3],[1,2],[1,0]] -b [5,15,5] -c [-2,-7] -t min –m 3

python main.py -A [[2,1,1],[1,2,3],[2,2,1]] -b [2,5,6] -c [-3,-1,-3] -t min –m 3
<!-- 4. python main.py -A [[2,1,-1,0],[1,1,0,-1]] -b [6,4] -c [3,2,0,0] -t min –m 3 -->
<!-- python main.py -A [[5,-4,13,-2,1],[1,-1,5,-1,1]] -b [20,8] -c [3,-1,-7,3,1] -t min –m 3 -->

Check unboundness examples:
5. python main.py -A [[1,0,-3,3],[0,1,-8,4]] -b [6,4] -c [0,0,3,-1] -t max –m 1
<!-- 6. python main.py -A [[1,-2],[1,0],[0,-1]] -b [6,10,-1] -c [3,5] -t max –m 1 -->


