# ContraProof

**A Formal Verification Engine for Contra Dance Choreography built in Lean 4.**

ContraProof is a mathematical state machine designed to parse and verify contra dance sequences. By mapping dancer identities (Larks/Robins and Ones/Twos) to transient geometric coordinates (Slots and Set Indexes), this engine tests choreography for structural integrity. 

It formally proves two elements of correctness:
1. **Phrasing:** Does the dance mathematically consume exactly 64 beats?
2. **Progression:** Does the sequence successfully advance Couple 1 down the hall and Couple 2 up the hall, while strictly returning all dancers to their correct relative starting slots?
---

## Project Architecture

The project separates the abstract topology of the dance hall from the specific choreographic figures.

### 1. `ContraProof/Structures.lean`
**The Topological Foundation.** 
This module defines the core data types that make up the state machine:
* **Permanent Identities:** `RoleType` (Lark/Robin) and `CoupleNum` (One/Two).
* **Transient Geography:** `Slot` (TopLeft, TopRight, etc.) representing geometric positions within a minor set, and `Position`, which pairs a slot with a `setIndex` (which minor set the dancer is currently in).
* **The State Machine:** `HallState`, a function mapping every `Dancer` to their current physical `Position`.
* **The Definition of a Dance:** `SpatialFigure` (a function that transforms a `HallState` into a new `HallState` over a specific number of `beats`), and `Dance` (a sequential list of figures).

### 2. `ContraProof/Figures.lean`
**The Geometric Transformations.**
This module defines the actual contra moves as mathematical state transformations:
* **Zero-Displacement:** `inPlace` moves for balances and do-si-dos.
* **Rotations:** `circleLeft` and `leftStar`, which rotate coordinates clockwise or counter-clockwise.
* **Active Resolutions:** `sideSwing`, which intelligently resolves dancers into the correct slots based on their `RoleType` (e.g., Larks finish on the left, Robins on the right).
* **Swaps:** `robinsChain` and role-based `allemande` figures that dynamically find a dancer's counterpart and swap their physical coordinates.
* **The Progression Flag:** `progress`, an explicit boundary-crossing figure that shifts dancers into adjacent minor sets (+1 or -1 `setIndex`).

### 3. `ContraProof/Verification.lean`
**The Theorem Prover Engine.**
This file contains the logic that judges the choreography:
* **Phrasing:** Computes `totalBeats` and checks against the standard 64-beat requirement.
* **Execution:** `runDance` folds the list of spatial figures over the initial `HallState`.
* **Strict Progression Logic:** `IsProgressive` (a formal mathematical `Prop`) and `checkProgressive` (a computable `Bool`). These functions enforce the "fractal" nature of contra: Couple 1 must move down the hall (+1), Couple 2 must move up (-1), **and** every dancer's final relative slot in the new set must match their initial starting slot, guaranteeing the formation is intact.

### 4. `Main.lean`
**The Executable Test Environment.**
* Defines starting formations (like `initialImproper`).
* Assembles specific choreographies into `Dance` lists (e.g., `babyYoda` and `babyRose`).
* Uses `#eval` to instantly run `checkPhrasing` and `checkProgressive` on sequences in the Lean 4 Infoview.

---

## Usage

To compile and run the verification engine from the command line:
```bash
lake build
lake exe contraproof
```

To evaluate a dance instantly, open `Main.lean` in VS Code and use the Lean 4 Infoview. The `#eval` commands paired with `checkPhrasing` and `checkProgressive` instantly output `true` or `false`.
---

## Valid Choreography Example
<iframe class="absolute top-0 left-0 w-full h-full" src="https://www.youtube-nocookie.com/embed/-1cPyJWm-g4" title="Crowfoot in Tacoma" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>