from problem import FishProblem
from searchAgent import MinMaxAgent
from minMaxAgent import FishProblemState

class Agent:
    """
    Agent that playes as one of the players in a 2 player fish game
    """

    def __init__(self, problem: FishProblem):
        self.problem = problem

    def MakeMove(self) -> list:
        """
        Function that predicts the next move based on the current state of the problem
        returns the moves as a list, the first entry of which is the barrel to remove from and remaining entries are addition to remaining barrels
        """
        pass


class EvenAgent(Agent):
    """
    Maintains the invariant that all barrels have an even number of fishes at the end of its turn
    """

    def MakeMove(self) -> list:
        outlist = []
        foundFirst = False
        for i, fishes in enumerate(self.problem.barrels):
            if foundFirst:
                if fishes%2:
                    outlist.append(1)
                else:
                    outlist.append(0)
            elif fishes%2:
                outlist.append(i)
                foundFirst = True
        
        if not foundFirst:
            lastIndex = self.problem.n - 1
            while lastIndex > 0 and self.problem.barrels[lastIndex] == 0:
                lastIndex -= 1

            outlist = [lastIndex]
        
        return outlist

    
class FishProblemMinMaxAgent(Agent):

    def __init__(self, problem: FishProblem):
        super().__init__(problem)

        self.agent = MinMaxAgent(FishProblemState(problem), 10) # Default depth 10 moves

    def MakeMove(self) -> list:
        return self.agent.GetBestMove()