from searchAgent import StateSpace
from problem import FishProblem

class FishProblemState(StateSpace):

    def __init__(self, problem : FishProblem, myTurn=True):
        self.problem = problem
        self.myTurn = myTurn 

        self._GenerateStateActionDict()

    def _SumCutoff(self) -> bool:
        return sum(self.problem.barrels) > 5*self.problem.n 

    def _GenerateAddCombinations(n):
        # Generate all {0,1}^n combinations
        # eg: _GenerateAddCombinations(2) = [(0,0), (0,1), (1,0), (1,1)]
        return tuple([
            tuple(
                map(
                    int, bin(i)[2:].rjust(n, '0')
                )
            )
            for i in range(2**n)
        ])

    def _GenerateActions(self):
        # Generate all actions possible for the current state of the problem.
        # Done by finding non empty barrels and the iterating over all 0 or 1 assignments to all lower barrels
        actionList = []
        for i in range(self.problem.n):
            if self.problem.barrels[i] != 0:
                actionList += [((i,) + combination) for combination in FishProblemState._GenerateAddCombinations(self.problem.n-i-1)]
        return actionList

    def _GenerateStateActionDict(self):
        outdict = {}
        for action in self._GenerateActions():
            childProblem = self.problem.Copy()
            childProblem.Move(*action)
            outdict[childProblem] = action

        self.stateActionDict = outdict # Caching
        return outdict


    def GetState(self):
        # Full state is problem and whose turn it is but this function isn't really all that useful
        return self.problem

    def GetChildren(self) -> list:
        # Go over each action and return the list of the state associated with each of these actions
        return [FishProblemState(problem, not self.myTurn) for problem in self._GenerateStateActionDict().keys()]

    def GetScore(self) -> int:

        # Is game is over, return 1 if this player (agent) won, else return -1
        if self.problem.IsOver(): 
            if self.myTurn:
                return -1
            else:
                return 1
            
        # This is an added restraint
        if self._SumCutoff():
            return -2
        return 0

    def IsTerminal(self) -> bool:
        return self.problem.IsOver() or self._SumCutoff() 

    def GetActionFromChild(self, state):
        return self.stateActionDict[state.problem]
        