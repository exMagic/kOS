global isDryTest is false.
local targetAltitude is 10000.
global stableSeconds is 0.

global ForeAngle is 0.
global StarAngle is 0.
global TopAngle is 0.
global StarNorthAngle is 0.
global ForeAngleToVel is 0.

global pichSpeed is 0.

global RollDiff is 0.
global RollSpeed is 0.
global RightOffset is 0.
global LeftOffset is 0.

global YawDiff is 0.
global YawSpeed is 0.
global YawOffset is 0.

global padLAT is -0.09721.
global PadLNG is -74.55766.
global LATSpeed is 0.
global LATDiff is 0.
global PichNavCorrection is 0.

global LNGSpeed is 0.
global LNGDiff is 0.
global RollNavCorrection is 0.

global previousPitch is 0.
global previousRoll is 0.
global previousYaw is 0.
global previousLat is 0.
global previousLng is 0.

global TLFAngle is 0.
global TRFAngle is 0.
global BLFAngle is 0.
global BRFAngle is 0.


global TopFlapAngle is 0. 
global BottomFlapAngle is 0.

global MaxFlapAngle is 180.
global MinFlapAngle is 90.
global TopFlapAngleDefoult is 135.
global BottomFlapAngleDefoult is 135.
global TargetForAngle is 90.

global StageNo is 0.
global lastCount is 0.
global th is 0.

SET vess to SHIP.
global partlist is vess:PARTSNAMED("hinge.04").



/////////////////////////////////////////////////////////////////////////////
////////////////////////////////// STAGES ///////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

stage.

until StageNo=1{
    // Ascent


    LOCK STEERING TO Up + R(0,0,180).
    set th to 0.7.
    lock throttle to th.           

          
}
