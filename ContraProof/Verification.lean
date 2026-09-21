-- ContraProof/Verification.lean
import ContraProof.Structures

-- 1. BEAT COUNT & PHRASING
-- Sum up the beats of all figures in the dance
def totalBeats (d : Dance) : Nat :=
  d.foldl (fun sum fig => sum + fig.beats) 0

-- The mathematical proposition that a dance has standard phrasing
def ValidPhrasing (d : Dance) : Prop :=
  totalBeats d = 64

-- A boolean checker so we can easily #eval the beat count in the Infoview
def checkPhrasing (d : Dance) : Bool :=
  totalBeats d == 64

-- 2. STATE EXECUTION
-- Run the transition functions sequentially over the HallState
def runDance (d : Dance) (s : HallState) : HallState :=
  d.foldl (fun current fig => fig.transition current) s

-- 3. PROGRESSION VERIFICATION (Prop)
-- The formal proposition that a dance progresses active couples down (+1),
-- inactive couples up (-1), and returns all dancers to their starting slots relative to the new minor set.
def IsProgressive (d : Dance) (initial : HallState) : Prop :=
  let final := runDance d initial

  -- Couple 1 moves down (+1) and retains initial relative slot
  (final ⟨CoupleNum.One, RoleType.Lark⟩) =
    { setIndex := (initial ⟨CoupleNum.One, RoleType.Lark⟩).setIndex + 1,
      slot := (initial ⟨CoupleNum.One, RoleType.Lark⟩).slot } ∧

  (final ⟨CoupleNum.One, RoleType.Robin⟩) =
    { setIndex := (initial ⟨CoupleNum.One, RoleType.Robin⟩).setIndex + 1,
      slot := (initial ⟨CoupleNum.One, RoleType.Robin⟩).slot } ∧

  -- Couple 2 moves up (-1) and retains initial relative slot
  (final ⟨CoupleNum.Two, RoleType.Lark⟩) =
    { setIndex := (initial ⟨CoupleNum.Two, RoleType.Lark⟩).setIndex - 1,
      slot := (initial ⟨CoupleNum.Two, RoleType.Lark⟩).slot } ∧

  (final ⟨CoupleNum.Two, RoleType.Robin⟩) =
    { setIndex := (initial ⟨CoupleNum.Two, RoleType.Robin⟩).setIndex - 1,
      slot := (initial ⟨CoupleNum.Two, RoleType.Robin⟩).slot }

-- 4. PROGRESSION CHECKER (Bool)
-- A computable boolean version of the progression check.
-- This is highly useful because you can use `#eval checkProgressive myDance myInitialState`
-- to immediately test a sequence without writing a formal tactic proof.
-- In ContraProof/Verification.lean

def checkProgressive (d : Dance) (initial : HallState) : Bool :=
  let final := runDance d initial

  -- Couple 1 must progress DOWN (+1) and resolve into their exact initial slots
  let l1_prog := (final ⟨CoupleNum.One, RoleType.Lark⟩) ==
                 { setIndex := (initial ⟨CoupleNum.One, RoleType.Lark⟩).setIndex + 1,
                   slot := (initial ⟨CoupleNum.One, RoleType.Lark⟩).slot }

  let r1_prog := (final ⟨CoupleNum.One, RoleType.Robin⟩) ==
                 { setIndex := (initial ⟨CoupleNum.One, RoleType.Robin⟩).setIndex + 1,
                   slot := (initial ⟨CoupleNum.One, RoleType.Robin⟩).slot }

  -- Couple 2 must progress UP (-1) and resolve into their exact initial slots
  let l2_prog := (final ⟨CoupleNum.Two, RoleType.Lark⟩) ==
                 { setIndex := (initial ⟨CoupleNum.Two, RoleType.Lark⟩).setIndex - 1,
                   slot := (initial ⟨CoupleNum.Two, RoleType.Lark⟩).slot }

  let r2_prog := (final ⟨CoupleNum.Two, RoleType.Robin⟩) ==
                 { setIndex := (initial ⟨CoupleNum.Two, RoleType.Robin⟩).setIndex - 1,
                   slot := (initial ⟨CoupleNum.Two, RoleType.Robin⟩).slot }

  l1_prog && r1_prog && l2_prog && r2_prog
