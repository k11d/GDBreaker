import itertools as it
import numpy as np
import time


class GameOfLife:

    EXAMPLES = dict(

        STABLE=[
            [0,0,0,0,0],
            [0,0,1,0,0],
            [0,1,0,1,0],
            [0,1,0,1,0],
            [0,0,1,0,0],
            [0,0,0,0,0],
        ],
   
        GLIDER = [
            [0,0,0,0,0,0],
            [0,0,0,0,0,0],
            [0,0,1,0,0,0],
            [0,0,0,1,1,0],
            [0,0,1,1,0,0],
            [0,0,0,0,0,0]
        ],
   
        SMALL_EXPLODER = [
            [0,0,0,0,0],
            [0,0,1,0,0],
            [0,1,1,1,0],
            [0,1,0,1,0],
            [0,0,1,0,0],
            [0,0,0,0,0]
        ]
    )



    GRID_TEMPLATE = EXAMPLES["STABLE"]
    _YBORDER = len(GRID_TEMPLATE)
    _XBORDER = len(GRID_TEMPLATE[0])


    def __init__(self, grid=None, xmax=None, ymax=None):
        g = grid or GameOfLife.EXAMPLES["GLIDER"]
        if type(g) == str and g in GameOfLife.EXAMPLES:
            g = GameOfLife.EXAMPLES[g]

        self.generation_count = 0
        self.cellgrid = self.parseGrid(g)

        # TODO: give user control over these
        self.auto_adjust = True
        self.tborder = 2
        self.bborder = 2
        self.rborder = 2
        self.lborder = 2

        ##

    def parseGrid(self, g):
        cg = set()
        for y in range(len(g)):
            for x in range(len(g[0])):
                if g[y][x] == 1:
                    cg.add((x,y))
        return cg


    def nextState(self):
        self.printGrid()
        self.generation_count += 1

        new_grid = set()
        recalc = self.cellgrid | set(it.chain(*map(self._xyNeighbors, self.cellgrid)))
        for pos in recalc:
            count = sum((n in self.cellgrid)
                        for n in self._xyNeighbors(pos))
            if count == 3 or (count == 2 and pos in self.cellgrid):
                new_grid.add(pos)

        self.cellgrid = self.adjust_borders(new_grid)


    def _min(self, grid=None):
        if grid is None:
            grid = self.cellgrid
        return (min(map(lambda p : p[0], grid)),
                min(map(lambda p : p[1], grid)))


    def _max(self, grid=None):
        if grid is None:
            grid = self.cellgrid
        return (max(map(lambda p : p[0], grid)),
                max(map(lambda p : p[1], grid)))


    def adjust_borders(self, grid):
        xmin, ymin = self._min(grid)
        tr_xs_key = lambda p : p[0] - xmin + self.lborder
        tr_ys_key = lambda p : p[1] - ymin + self.tborder
        return set(zip(map(tr_xs_key, grid),
                          map(tr_ys_key, grid)))


    def construct_2d_grid(self, grid):
        xmax, ymax = self._max(grid)
        _sgrid = []
        for y in range(ymax + self.rborder):
            _row = []
            for x in range(xmax + self.bborder):
                if (x,y) in grid:
                    _row.append(1)
                else:
                    _row.append(0)
            _sgrid.append(_row)
        return _sgrid


    def printGrid(self):
        print('\n' * 100)
        print(f"#G:{self.generation_count}")
        print(
            np.matrix(
                self.construct_2d_grid(self.cellgrid)))


    def _xyNeighbors(self, xy):
        x,y = xy[0], xy[1]
        yield x - 1, y - 1
        yield x - 1, y
        yield x - 1, y + 1
        yield x, y - 1
        yield x, y + 1
        yield x + 1, y + 1
        yield x + 1, y
        yield x + 1, y - 1


def runGame(game=None, args=()):
    if game is None:
        game = GameOfLife(*args)
    elif callable(game):
        game = game(*args)

    while True:
        try:
            game.nextState()
            time.sleep(0.2)
        except KeyboardInterrupt:
            print()
            return 0
        except Exception as e:
            print(e)
            break
    return 1



if __name__ == '__main__':
    # runGame(GameOfLife, args=('STABLE',))
    runGame(GameOfLife, args=('GLIDER',))


