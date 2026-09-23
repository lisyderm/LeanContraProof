-- Main.lean
import ContraProof.Structures
import ContraProof.Figures
import ContraProof.Verification

-- ==========================================
-- Dances for Testing
-- ==========================================

-- The Baby Yoda: starting state is improper w/neighbor swing
def babyYoda : Dance := {
  name := "The Baby Yoda",
  beats := 64,
  formation := initialImproperWithNeighborSideSwing,
  figures := [
    circleLeft 3 8,
    inPlace "Partners do si do once" 8,
    inPlace "Partners balance" 4,
    sideSwing "Partners swing" 12,
    robinsChain 8,
    leftStar 4 8,
    progress "Onto new neighbors" 0, -- Pushes dancers into the adjacent set
    inPlace "New Neighbor Balance" 4,
    sideSwing "Neighbors swing" 12
  ]
}

-- The Baby Rose, should pass tests
def babyRose : Dance := {
  name := "The Baby Rose",
  beats := 64,
  formation := initialImproper,
  figures := [
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
}

-- Easy Peasy by Diane Silver, should pass tests
def easyPeasy : Dance := {
  name := "Easy Peasy",
  beats := 64,
  formation := initialImproper,
  figures := [
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
}

-- ==========================================
-- VERIFICATION TESTS
-- ==========================================

-- Test Baby Rose
#eval checkBeats babyRose
#eval checkProgressive babyRose
theorem babyRose_phrasing : ValidBeats babyRose := rfl
theorem babyRose_progression : IsProgressive babyRose := rfl

-- Test Baby Yoda
#eval checkBeats babyYoda
#eval checkProgressive babyYoda
theorem babyYoda_phrasing : ValidBeats babyYoda := rfl
theorem babyYoda_progression : IsProgressive babyYoda := rfl


-- Test Easy Peasy
#eval checkBeats easyPeasy
#eval checkProgressive easyPeasy
theorem easyPeasy_phrasing : ValidBeats easyPeasy := rfl
theorem easyPeasy_progression : IsProgressive easyPeasy := rfl


def main : IO Unit := do
  IO.println "Evaluating The Baby Yoda Phrasing (Expect true):"
  IO.println (checkBeats babyYoda)
  IO.println "\nEvaluating The Baby Yoda Progression (Expect true):"
  IO.println (checkProgressive babyYoda)
  IO.println "Evaluating The Baby Rose Phrasing (Expect true):"
  IO.println (checkBeats babyRose)
  IO.println "\nEvaluating The Baby Rose Progression (Expect true):"
  IO.println (checkProgressive babyRose)
