-- RoleType, Slot, Dancer, HallState, and SpatialFigure

-- We need a topological state machine to track dancers progressing (actives move down the set, inactives move up)

-- Role type of a dancer never changes
inductive RoleType
  | Lark
  | Robin
  deriving Repr, DecidableEq

-- for an infinite major set, the couple number never changes
-- but if it is finite at the tops and bottoms they sit out for a round,
-- then turn around, swap couple number and rejoin the majors set
inductive CoupleNum
  | One  -- Actives (progress down the hall)
  | Two  -- Inactives (progress up the hall)
  deriving Repr, DecidableEq

--
structure Dancer where
  couple : CoupleNum
  role : RoleType
  deriving Repr, DecidableEq

-- Define the slots geometrically
inductive Slot
  | TopLeft
  | TopRight
  | BottomRight
  | BottomLeft
  deriving Repr, DecidableEq

-- Absolute coordinates in the hall
structure Position where
  setIndex : Int
  slot : Slot
  deriving Repr, DecidableEq

-- 3. THE HALL STATE
-- Instead of a MinorSet holding dancers, the Hall State is a function
-- mapping every Dancer to their current physical Position.
def HallState := Dancer → Position

-- 4. FIGURES AS TOPOLOGICAL TRANSFORMATIONS
-- A figure moves dancers to new positions based on where they currently stand.
structure SpatialFigure where
  name : String
  beats : Nat
  -- In a full implementation, this function calculates the new Position
  -- (both `slot` and `setIndex`) based on the geometry of the move.
  transition : HallState → HallState


def Dance := List SpatialFigure
