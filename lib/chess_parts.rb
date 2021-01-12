module ChessParts
 PIECE_SET = { 'rook'=> {image: " \u265C  ", row: 1, count: 2, alpha: ['a', 'h'] },
               'knight'=> {image: " \u265E  ", row: 1, count: 2, alpha: ['b', 'g'] },
               'bishop'=> {image: " \u265D  ", row: 1, count: 2, alpha: ['c', 'f'] },
               'queen'=> {image: " \u265B  ", row: 1, count: 1, alpha: ['d'] },
               'king'=> {image: " \u265A  ", row: 1, count: 1, alpha: ['e'] },
               'pawn'=> {image: " \u265F  ", row: 2, count: 8, alpha: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'] } }

  X_COORDINATES = '   a    b   c   d   e   f   g   h'
end