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

-- THE HALL STATE
-- Instead of a MinorSet holding dancers, the Hall State is a function
-- mapping every Dancer to their current physical Position.
def HallState := Dancer → Position

structure SpatialFigure where
  name : String
  beats : Nat
  transition : HallState → HallState

-- A Formation bundles the hall layout with the participating dancers
structure Formation where
  state : HallState
  dancers : List Dancer

-- INITIAL STATES (Dance Starting Formations)

def twoCoupleDancers : List Dancer := [
  ⟨CoupleNum.One, RoleType.Lark⟩,
  ⟨CoupleNum.One, RoleType.Robin⟩,
  ⟨CoupleNum.Two, RoleType.Lark⟩,
  ⟨CoupleNum.Two, RoleType.Robin⟩
]

def initialImproper : Formation := {
  state := fun dancer =>
    match dancer.couple with
    | CoupleNum.One =>
        match dancer.role with
        | RoleType.Lark  => { setIndex := 0, slot := Slot.TopRight }
        | RoleType.Robin => { setIndex := 0, slot := Slot.TopLeft }
    | CoupleNum.Two =>
        match dancer.role with
        | RoleType.Lark  => { setIndex := 0, slot := Slot.BottomLeft }
        | RoleType.Robin => { setIndex := 0, slot := Slot.BottomRight },
  dancers := twoCoupleDancers
}

def initialImproperWithNeighborSideSwing : Formation := {
  state := fun dancer =>
    match dancer.couple with
    | CoupleNum.One =>
        match dancer.role with
        | RoleType.Lark  => { setIndex := 0, slot := Slot.BottomRight }
        | RoleType.Robin => { setIndex := 0, slot := Slot.BottomLeft }
    | CoupleNum.Two =>
        match dancer.role with
        | RoleType.Lark  => { setIndex := 0, slot := Slot.TopLeft }
        | RoleType.Robin => { setIndex := 0, slot := Slot.TopRight },
  dancers := twoCoupleDancers
}

structure Dance where
  name : String
  beats: Nat
  formation : Formation
  figures : List SpatialFigure
