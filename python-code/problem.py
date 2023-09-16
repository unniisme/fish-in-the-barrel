
import random

class FishProblem:
    """
    Barrel number i, if taken from, allows a player to add to all barrels numbered i+1 to n-1
    """
    RAND_MIN = 1
    RAND_MAX = 7
    ADD_MAX = 5
    ADD_MIN = 0

    def __init__(self, n : int, *args):
        """
        Initialize a fish barrel problem with n barrels

        args:
        n : number of barrels
        each argument after n is the number of fishes in each consecutive barrel.
        Unfilled arguments will be randomly generated
        """
        self.n = n
        self.barrels = []
        for i in range(n):
            try:
                self.barrels.append(args[i])
            except:
                self.barrels.append(random.randint(FishProblem.RAND_MIN,FishProblem.RAND_MAX))

    def Copy(self):
        return FishProblem(self.n, *self.barrels)
    
    def __hash__(self) -> int:
        return (tuple(self.barrels)).__hash__()

    
    # Queries
    def IsOver(self) -> bool:
        return sum(self.barrels) == 0

    def __str__(self):
        return " ".join([ "[ " + str(x) + " ]" for x in self.barrels])
    
    # Modifiers
    def Move(self, k : int, *subs) -> bool:
        """
        arguments should be change in each barrel.
        1 fish will be taken from the kth barrel, remaining arguments will be used to add fishes to the remaining barrels.
        """
        if self.barrels[k] == 0:
            return False

        self.barrels[k] -= 1
        upper = min(self.n, k+1+len(subs))
        for i in range(k+1, upper):
            self.barrels[i] += subs[i-(k+1)]

        return True
    
    def __repr__(self):
        return f"{self.n} {self.barrels}"

    