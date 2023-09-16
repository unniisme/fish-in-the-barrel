from problem import FishProblem

class FishGame:
    """
    An instance of the fish problem, involving 2 players.
    There could be different definitions of the game.
    """
    class Players:
        """
        Wrapper for holding 2 player info
        """
        def __init__(self, name1, name2):
            self.playing = 0
            self.victory = -1
            self.names = [name1, name2]
        
        # Queries
        def GetPlaying(self) -> str:
            return self.names[self.playing]

        def IsWon(self) -> bool:
            return self.victory >= 0

        def GetWinner(self) -> str:
            return self.names[self.victory]
        
        # Actions
        def SwitchPlayer(self):
            self.playing = 1 - self.playing
        
        def SetWinner(self, name):
            try:
                self.victory = self.names.index(name)
            except ValueError:
                raise ValueError("Unknown player")


    def __init__(self, problem : FishProblem):
        self.problem = problem
        self.players = FishGame.Players("1", "2")

    def Move(self, n : int, *args) -> bool:
        """
        Input is the number of the barrel from which a fish is being deducted, followed by number of fish to add to each subsequest barrel
        """
        if not self.problem.Move(n, *args):
            return False
        if self.problem.IsOver(): 
            self.players.SetWinner(self.players.GetPlaying())

        self.players.SwitchPlayer()
        return True


if __name__ == "__main__":
    problem = FishProblem(4)
    game = FishGame(problem)

    while not game.players.IsWon():
        print(problem)
        if not game.Move(*(
            list(
                map(
                    int, input("Player " + game.players.GetPlaying() + "'s turn\n").split()
                    )
                )
            )
        ):
            print("Invalid move")

    game.players.SwitchPlayer()
    print("Player " + game.players.GetWinner() + " won")


        
        



