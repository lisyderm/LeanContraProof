-- Main.lean
import ContraProof.Structures
import ContraProof.Figures
import ContraProof.Verification

-- ==========================================
-- 1. INITIAL STATE (The Starting Formation)
-- ==========================================

-- Defines a standard improper starting formation for a minor set at setIndex 0.
def initialImproper : HallState := fun dancer =>
  match dancer.couple, dancer.role with
  -- Actives (Couple 1) start at the top
  | CoupleNum.One, RoleType.Lark  => { setIndex := 0, slot := Slot.TopRight }
  | CoupleNum.One, RoleType.Robin => { setIndex := 0, slot := Slot.TopLeft }
  -- Inactives (Couple 2) start at the bottom, crossed
  | CoupleNum.Two, RoleType.Lark  => { setIndex := 0, slot := Slot.BottomLeft }
  | CoupleNum.Two, RoleType.Robin => { setIndex := 0, slot := Slot.BottomRight }

-- ==========================================
-- 2. THE CHOREOGRAPHY
-- ==========================================

-- Bob Crawford's transcription of The Baby Yoda
def babyYoda : Dance := [
  circleLeft 3 8,
  inPlace "Partners do si do once" 8,
  inPlace "Partners balance" 4,
  sideSwing "Partners swing" 12,
  robinsChain 8,
  leftStar 4 8,
  -- Pushes dancers into the adjacent set & checks direction of travel
  progress "Onto new neighbors" 0,
  inPlace "New Neighbor Balance" 4,
  sideSwing "Neighbors swing" 12
]

-- The Baby Rose, should pass tests
def babyRose : Dance := [
  inPlace "New Neighbor Balance" 4,
  sideSwing "Neighbors swing" 12,
  circleLeft 3 8,
  inPlace "Partners do si do once" 8,
  inPlace "Partners balance" 4,
  sideSwing "Partners swing" 12,
  robinsChain 8,
  leftStar 4 8,
  -- Pushes dancers into the adjacent set & checks direction of travel
  progress "Onto new neighbors" 0
]

-- Easy Peasy by Diane Silver, should pass tests
def easyPeasy : Dance := [
  inPlace "New Neighbor Balance" 4,
  sideSwing "Neighbors swing" 12,
  inPlace "Long lines forward back" 8,
  allemandeLarks 6 8,
  inPlace "Partners balance" 4,
  sideSwing "Partners swing" 12,
  circleLeft 3 8,
  inPlace "Balance the ring" 4,
  caliTwirl "Partners California Twirl" 4,
  -- Pushes dancers into the adjacent set & checks direction of travel
  progress "Onto new neighbors" 0
]

-- ==========================================
-- 3. THE VERIFICATION TESTS
-- ==========================================

-- Check if the total beat count equals 64
#eval checkPhrasing babyYoda
#eval checkPhrasing babyRose
#eval checkPhrasing easyPeasy

-- Check if the topology successfully progresses the couples
#eval checkProgressive babyYoda initialImproper
#eval checkProgressive babyRose initialImproper
#eval checkProgressive easyPeasy initialImproper



def main : IO Unit := do
  IO.println "Evaluating The Baby Yoda Phrasing (Expect true):"
  IO.println (checkPhrasing babyYoda)
  IO.println "\nEvaluating The Baby Yoda Progression (Expect false):"
  IO.println (checkProgressive babyYoda initialImproper)
  IO.println "Evaluating The Baby Rose Phrasing (Expect true):"
  IO.println (checkPhrasing babyRose)
  IO.println "\nEvaluating The Baby Rose Progression (Expect true):"
  IO.println (checkProgressive babyRose initialImproper)
