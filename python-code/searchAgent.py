

class StateSpace:
    """
    Interface for defining the statespace for a search problem
    """

    def GetState(self):
        pass

    def GetChildren(self) -> list:
        pass

    def GetScore(self) -> int:
        pass

    def IsTerminal(self) -> bool:
        pass

    def GetActionFromChild(self, state):
        pass



class MinMaxAgent:
    """
    MinMaxAgent that works on the statespace intefrace defined above
    """

    stats = {"nodes" : 0, "children"  : 0}

    def __init__(self, searchSpace : StateSpace, maxDepth : int):
        self.startState = searchSpace
        self.maxDepth = maxDepth

    def _minStep(self, state : StateSpace, depth : int):
        print(MinMaxAgent.stats)

        if depth > self.maxDepth or state.IsTerminal():
            return state.GetScore()

        return min([self._maxStep(x, depth + 1) for x in state.GetChildren()] + [float("inf")])
    
    def _maxStep(self, state : StateSpace, depth : int):
        print(MinMaxAgent.stats)

        if depth > self.maxDepth or state.IsTerminal():
            return state.GetScore()

        return max([self._minStep(x, depth + 1) for x in state.GetChildren()] + [float("-inf")])
    
    def GetBestMove(self):
        """
        Returns move that has the highest score among all current moves
        """
        # return max(
        #     [(self._minStep(neighbor, 0), self.startState.GetActionFromChild(neighbor)) 
        #      for neighbor in self.startState.GetChildren()]
        #      )[1]
        moveList = []
        for neighbor in self.startState.GetChildren():
            MinMaxAgent.stats["children"] += 1
            moveList.append((self._minStep(neighbor, 0), self.startState.GetActionFromChild(neighbor)))

        return max(moveList)[1]
        
