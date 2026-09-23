-- ContraProof/Verification.lean
import ContraProof.Structures

----------------------
-- STATE EXECUTION
----------------------
-- Run the transition functions sequentially over the HallState
def runDance (d : Dance) : HallState :=
  d.figures.foldl (fun current fig => fig.transition current) d.formation.state

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
-- Determine the required progression direction based on the couple number
def expectedDelta (c : CoupleNum) : Int :=
  match c with
  | CoupleNum.One => 1   -- Actives always move down
  | CoupleNum.Two => -1  -- Inactives always move up

def checkDancer (initial final : HallState) (dancer : Dancer) : Bool :=
  let p := final dancer
  let i := initial dancer
  let delta := expectedDelta dancer.couple
  p.setIndex == i.setIndex + delta && p.slot == i.slot

def checkProgressive (d : Dance) : Bool :=
  let initial := d.formation.state
  let final := runDance d
  d.formation.dancers.all (fun dancer => checkDancer initial final dancer)

-- The formal proposition that a dance is progressive
-- Define IsProgressive as a Prop tied to the Bool checker
def IsProgressive (d : Dance) : Prop :=
  checkProgressive d = true
