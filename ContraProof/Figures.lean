-- ContraProof/Figures.lean
import ContraProof.Structures

-- ==========================================
-- 1. ZERO-DISPLACEMENT FIGURES
-- ==========================================

-- A figure that takes up beats but doesn't change a dancer's slot or setIndex
def inPlace (name : String) (beats : Nat) : SpatialFigure :=
  { name := name,
    beats := beats,
    transition := fun state => state -- Identity function
  }

-- ==========================================
-- SWAPS Along and Across
-- ==========================================

-- Swapping up and down the side lines
def swapAlong : Slot → Slot
  | Slot.TopLeft     => Slot.BottomLeft
  | Slot.BottomLeft  => Slot.TopLeft
  | Slot.TopRight    => Slot.BottomRight
  | Slot.BottomRight => Slot.TopRight

-- Swapping partners across the set
def swapAcross : Slot → Slot
  | Slot.TopLeft     => Slot.TopRight
  | Slot.TopRight    => Slot.TopLeft
  | Slot.BottomLeft  => Slot.BottomRight
  | Slot.BottomRight => Slot.BottomLeft

-- ==========================================
-- ROTATIONS (Circles and Stars)
-- ==========================================

-- Circle Left (Clockwise rotation of slots)
def rotateCW : Slot → Slot
  | Slot.TopLeft     => Slot.TopRight
  | Slot.TopRight    => Slot.BottomRight
  | Slot.BottomRight => Slot.BottomLeft
  | Slot.BottomLeft  => Slot.TopLeft

def rotateCWPlaces (places : Nat) (s : Slot) : Slot :=
  match places with
  | 0 => s
  | n + 1 => rotateCWPlaces n (rotateCW s)

def circleLeft (places : Nat) (beats : Nat) : SpatialFigure :=
  { name := s!"Circle Left {places} places",
    beats := beats,
    transition := fun state dancer =>
      let pos := state dancer
      { setIndex := pos.setIndex, slot := rotateCWPlaces places pos.slot }
  }

def rightStar (places : Nat) (beats : Nat) : SpatialFigure :=
  { name := s!"Right Hand Star {places} places",
    beats := beats,
    transition := fun state dancer =>
      let pos := state dancer
      { setIndex := pos.setIndex, slot := rotateCWPlaces places pos.slot }
  }

-- Left Star (Counter-Clockwise rotation of slots)
def rotateCCW : Slot → Slot
  | Slot.TopLeft     => Slot.BottomLeft
  | Slot.BottomLeft  => Slot.BottomRight
  | Slot.BottomRight => Slot.TopRight
  | Slot.TopRight    => Slot.TopLeft

def rotateCCWPlaces (places : Nat) (s : Slot) : Slot :=
  match places with
  | 0 => s
  | n + 1 => rotateCCWPlaces n (rotateCCW s)

def circleRight (places : Nat) (beats : Nat) : SpatialFigure :=
  { name := s!"Circle Right {places} places",
    beats := beats,
    transition := fun state dancer =>
      let pos := state dancer
      { setIndex := pos.setIndex, slot := rotateCCWPlaces places pos.slot }
  }

def leftStar (places : Nat) (beats : Nat) : SpatialFigure :=
  { name := s!"Left Hand Star {places} places",
    beats := beats,
    transition := fun state dancer =>
      let pos := state dancer
      { setIndex := pos.setIndex, slot := rotateCCWPlaces places pos.slot }
  }

-- ==========================================
-- SWAPS (Chains, Cali Twirls, Allemande, R-L Through, Promenade)
-- ==========================================

-- A Robins Chain across an improper set swaps the diagonal slots
-- TODO: this is the most common chain, but it's a right hand chain
-- need to add a left hand chain and generalize for both roles
def chainSwap : Slot → Slot
  | Slot.BottomLeft => Slot.TopRight
  | Slot.TopRight   => Slot.BottomLeft
  | other           => other -- Larks in TopLeft and BottomRight stay in place

def robinsChain (beats : Nat) : SpatialFigure :=
  { name := "Robins Chain",
    beats := beats,
    transition := fun state dancer =>
      let pos := state dancer
      { setIndex := pos.setIndex, slot := chainSwap pos.slot }
  }

def allAcrossSwap : Slot → Slot
  | Slot.BottomLeft => Slot.BottomRight
  | Slot.BottomRight => Slot.BottomLeft
  | Slot.TopLeft   => Slot.TopRight
  | Slot.TopRight   => Slot.TopLeft

def caliTwirl (name : String) (beats : Nat) : SpatialFigure :=
  { name := name,
    beats := beats,
    transition := fun state dancer =>
      let pos := state dancer
      { setIndex := pos.setIndex, slot := allAcrossSwap pos.slot }
  }

-- ==========================================
-- ROLE-BASED Diagonal Across ALLEMANDE FIGURES
-- ==========================================

-- Helper to find the other couple
def otherCouple (c : CoupleNum) : CoupleNum :=
  match c with
  | CoupleNum.One => CoupleNum.Two
  | CoupleNum.Two => CoupleNum.One

-- def allemandeRobins (halfTurns : Nat) (beats : Nat) : SpatialFigure :=
--   { name := s!"Robins Allemande {halfTurns}/2",
--     beats := beats,
--     transition := fun state dancer =>
--       if halfTurns % 2 == 0 then
--         state dancer -- Whole turn resolves in place
--       else
--         match dancer.role with
--         | RoleType.Lark => state dancer -- Larks stay put
--         | RoleType.Robin =>
--             -- Look up the physical slot of the OTHER Robin and take it
--             let partnerPos := state ⟨otherCouple dancer.couple, RoleType.Robin⟩
--             { setIndex := (state dancer).setIndex, slot := partnerPos.slot }
--   }

-- Example usage: allemandeRobins 6 8 (An allemande 1.5x (which is 6/4), taking 8 beats)
def allemandeRobins (quarterTurns : Nat) (beats : Nat) : SpatialFigure :=
  { name := s!"Robins Allemande {quarterTurns}/4",
    beats := beats,
    transition := fun state dancer =>
      match quarterTurns % 4 with
      -- Whole turns (4/4, 8/4)
      | 0 => state dancer

      -- Half turns (2/4, 6/4) -> Swap
      | 2 =>
          match dancer.role with
          | RoleType.Lark => state dancer
          | RoleType.Robin =>
              let partnerPos := state ⟨otherCouple dancer.couple, RoleType.Robin⟩
              { setIndex := (state dancer).setIndex, slot := partnerPos.slot }

      -- Quarter turns (1/4, 3/4, 5/4) -> 90 degree offsets
      | 1 | 3 =>
          -- Placeholder: Requires new slot definitions!
          state dancer

      -- Fallback for compiler safety
      | _ => state dancer
  }

-- def allemandeLarks (halfTurns : Nat) (beats : Nat) : SpatialFigure :=
--   { name := s!"Larks Allemande {halfTurns}/2",
--     beats := beats,
--     transition := fun state dancer =>
--       if halfTurns % 2 == 0 then
--         state dancer
--       else
--         match dancer.role with
--         | RoleType.Robin => state dancer -- Robins stay put
--         | RoleType.Lark =>
--             let partnerPos := state ⟨otherCouple dancer.couple, RoleType.Lark⟩
--             { setIndex := (state dancer).setIndex, slot := partnerPos.slot }
--   }

  def allemandeLarks (quarterTurns : Nat) (beats : Nat) : SpatialFigure :=
  { name := s!"Larks Allemande {quarterTurns}/4",
    beats := beats,
    transition := fun state dancer =>
      match quarterTurns % 4 with
      -- Whole turns (4/4, 8/4)
      | 0 => state dancer

      -- Half turns (2/4, 6/4) -> Swap
      | 2 =>
          match dancer.role with
          | RoleType.Robin => state dancer
          | RoleType.Lark =>
              let partnerPos := state ⟨otherCouple dancer.couple, RoleType.Lark⟩
              { setIndex := (state dancer).setIndex, slot := partnerPos.slot }

      -- Quarter turns (1/4, 3/4, 5/4) -> 90 degree offsets
      | 1 | 3 =>
          -- Placeholder: Requires new slot definitions!
          state dancer

      -- Fallback for compiler safety
      | _ => state dancer
  }

-- ==========================================
-- Along the Side ALLEMANDE FIGURES
-- ==========================================

-- Example usage: allemandeAlong 3 8 (an allemande 1.5x taking 8 beats)
def allemandeAlong (halfTurns : Nat) (beats : Nat) : SpatialFigure :=
  { name := s!"Allemande along the set {halfTurns}/2",
    beats := beats,
    transition := fun state dancer =>
      let pos := state dancer
      if halfTurns % 2 == 0 then
        pos -- Whole turn: Identity (in place)
      else
        { setIndex := pos.setIndex, slot := swapAlong pos.slot } -- Half turn: Swap
  }

-- ==========================================
-- ACTIVE RESOLUTIONS (Swings)
-- ==========================================

-- Resolves a dancer's slot based on their Role (Lark/Robin)
-- and which side of the set they are currently swinging on.
def resolveSwingSlot (role : RoleType) (currentSlot : Slot) : Slot :=
  match currentSlot with
  -- Left side of the set (facing across to the right)
  | Slot.TopLeft | Slot.BottomLeft =>
      match role with
      | RoleType.Lark  => Slot.TopLeft
      | RoleType.Robin => Slot.BottomLeft

  -- Right side of the set (facing across to the left)
  | Slot.TopRight | Slot.BottomRight =>
      match role with
      | RoleType.Lark  => Slot.BottomRight
      | RoleType.Robin => Slot.TopRight

def sideSwing (name : String) (beats : Nat) : SpatialFigure :=
  { name := name,
    beats := beats,
    transition := fun state dancer =>
      let pos := state dancer
      { setIndex := pos.setIndex,
        slot := resolveSwingSlot dancer.role pos.slot }
  }

-- ==========================================
-- BOUNDARY CROSSING (Next Neighbors)
-- ==========================================

-- Map a dancer's coordinates to the adjacent minor set
def crossBoundary (pos : Position) : Position :=
  match pos.slot with
  -- Dancers at the bottom look down the hall (+1)
  | Slot.BottomLeft  => { setIndex := pos.setIndex + 1, slot := Slot.TopLeft }
  | Slot.BottomRight => { setIndex := pos.setIndex + 1, slot := Slot.TopRight }

  -- Dancers at the top look up the hall (-1)
  | Slot.TopLeft     => { setIndex := pos.setIndex - 1, slot := Slot.BottomLeft }
  | Slot.TopRight    => { setIndex := pos.setIndex - 1, slot := Slot.BottomRight }

-- A universal progression flag that can occur anywhere in the dance timeline
def progress (name : String) (beats : Nat) : SpatialFigure :=
  { name := name,
    beats := beats,
    transition := fun state dancer => crossBoundary (state dancer)
  }
