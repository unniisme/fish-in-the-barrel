from agents import EvenAgent
from agents import FishProblemMinMaxAgent
from games import FishGame
from problem import FishProblem

# problem = FishProblem(4, 4,5,3,1)
problem = FishProblem(4, 4,5,3,1)
game = FishGame(problem)
agent = FishProblemMinMaxAgent(problem)

while not game.players.IsWon():
    print(problem)
    if game.players.GetPlaying() == "2":
        print("Player 2's turn")
        agentMove = agent.MakeMove()
        print(agentMove)
        assert game.Move(*agent.MakeMove())

    else:
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