-- ContraProof/Verification.lean
import ContraProof.Structures

----------------------
-- STATE EXECUTION
----------------------
-- Run the transition functions sequentially over the HallState
def runDance (d : Dance) : HallState :=
  d.figures.foldl (fun current fig => fig.transition current) d.startingFormation

----------------------
-- Verify Beat Count
----------------------
-- Sum up the beats of all figures in the dance
def totalBeats (d : Dance) : Nat :=
  d.figures.foldl (fun sum fig => sum + fig.beats) 0

-- A boolean checker so we can #eval the beat count in Infoview
def checkBeats (d : Dance) : Bool :=
  totalBeats d == d.beats

-- The mathematical proposition that a dance has standard phrasing
def ValidBeats (d : Dance) : Prop :=
  checkBeats d = true

----------------------
-- Verify Progression
----------------------
-- A helper checker for the computable Bool evaluation
def checkDancer (initial final : HallState) (c : CoupleNum) (r : RoleType) (delta : Int) : Bool :=
  let p := final ⟨c, r⟩
  let i := initial ⟨c, r⟩
  p.setIndex == i.setIndex + delta && p.slot == i.slot

-- The computable boolean version for #eval testing
def checkProgressive (d : Dance) : Bool :=
  let initial := d.startingFormation
  let final := runDance d
  checkDancer initial final CoupleNum.One RoleType.Lark 1 &&
  checkDancer initial final CoupleNum.One RoleType.Robin 1 &&
  checkDancer initial final CoupleNum.Two RoleType.Lark (-1) &&
  checkDancer initial final CoupleNum.Two RoleType.Robin (-1)

-- The formal proposition that a dance is progressive
-- Define IsProgressive as a Prop tied to the Bool checker
def IsProgressive (d : Dance) : Prop :=
  checkProgressive d = true
